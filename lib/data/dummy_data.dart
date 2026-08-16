import 'package:mo_ashraf/models/experience_model.dart';
import 'package:mo_ashraf/models/profile_model.dart';
import 'package:mo_ashraf/models/project_model.dart';
import 'package:mo_ashraf/models/skill_model.dart';

class DummyData {
  static final profile = ProfileModel(
    name: 'Mohamed Ashraf Mahmoud',
    brandName: 'MA Team',
    title: 'Photo Retoucher',
    subtitle: 'Product | Food | Cosmetics | Fashion | Commercial',
    tagline: 'Clean pixels, sharp details, premium delivery',
    summary:
        'Detail-oriented retoucher with 4+ years of experience in product, food, cosmetics, fashion, advertising, virtual tours, and commercial post-production. Skilled in Photoshop, Lightroom, Capture One Pro, Affinity Photo, 3D Vista, and retouching panels, with leadership experience managing remote photo editors.',
    photoUrl: 'assets/me.jpeg',
    studioPhotoUrl: 'assets/office/officef.jpeg',
    cvUrl: 'assets/cv/Mohamed Ashraf Mahmoud .pdf',
    email: 'Mohamedmmnss90@gmail.com',
    phone: '+20 1008863394',
    location: 'Egypt',
    socialLinks: const {
      'behance': 'https://www.behance.net/mohamedashraf516',
      'whatsapp': 'https://wa.me/201008863394',
    },
    stats: const {
      'projectsCount': '150+',
      'yearsExperience': '4+',
      'clientsCount': '50+',
    },
  );

  static final experiences = <ExperienceModel>[
    ExperienceModel(
      id: 'dummy-feer',
      company: 'FEER McQUEEN',
      role: 'Senior Retoucher',
      startDate: 'May 2025',
      endDate: 'Present',
      isCurrent: true,
      description:
          'Started as a full-time retoucher, then transitioned to a freelance retainer role providing ongoing professional retouching services.',
      order: 0,
    ),
    ExperienceModel(
      id: 'dummy-crafters',
      company: 'Crafters.space, Saudi Arabia - Remote',
      role: 'Freelance Retoucher',
      startDate: 'Mar 2024',
      endDate: 'Present',
      isCurrent: true,
      description:
          'Completed multiple product retouching projects and delivered high-quality results within tight deadlines.',
      order: 1,
    ),
    ExperienceModel(
      id: 'dummy-black-lines',
      company: 'Black Lines, Egypt - Remote',
      role: 'Photo Retoucher / Team Leader',
      startDate: 'Mar 2024',
      endDate: 'Dec 2024',
      description:
          'Handled high-quality image editing and post-production for virtual tours and commercial projects. Promoted to Team Leader after 3 months and managed a remote team of photo editors.',
      order: 2,
    ),
    ExperienceModel(
      id: 'dummy-ebba',
      company: 'EBBA, United Arab Emirates - Remote',
      role: 'Retoucher',
      startDate: 'Dec 2023',
      endDate: 'Dec 2024',
      description:
          'Retouched food, fashion, and advertising images while collaborating with photographers and clients.',
      order: 3,
    ),
    ExperienceModel(
      id: 'dummy-belva',
      company: 'Belvaphilips.imagery, United States - Remote',
      role: 'Retoucher',
      startDate: 'Dec 2021',
      endDate: 'Dec 2023',
      description:
          'Retouched product, fashion, and advertising images using Photoshop, Lightroom, and Capture One Pro.',
      order: 4,
    ),
  ];

  static final projects = <ProjectModel>[
    ProjectModel(
      id: 'mcdonalds-burger-hero',
      title: "McDonald's Burger Hero Shot",
      description:
          'Demo commercial food retouching with texture cleanup, appetizing color grading, steam contrast, and campaign-ready finishing.',
      category: 'Food',
      imageUrls: const [
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1200&q=80',
      ],
      client: "McDonald's",
      date: '2025',
      isFeatured: true,
      order: 0,
    ),
    ProjectModel(
      id: 'mcdonalds-fries',
      title: "McDonald's Fries Campaign",
      description:
          'Demo fries advertising edit focused on golden tones, crisp texture, salt detail, and clean product separation.',
      category: 'Food',
      imageUrls: const [
        'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?auto=format&fit=crop&w=1200&q=80',
      ],
      client: "McDonald's",
      date: '2025',
      isFeatured: true,
      order: 1,
    ),
    ProjectModel(
      id: 'mcdonalds-menu-board',
      title: "McDonald's Menu Visuals",
      description:
          'Demo menu-board post-production with consistent whites, rich reds, clean shadows, and polished delivery files.',
      category: 'Food',
      imageUrls: const [
        'https://images.unsplash.com/photo-1619881589316-56c7f9e6b587?auto=format&fit=crop&w=1200&q=80',
      ],
      client: "McDonald's",
      date: '2024',
      order: 2,
    ),
    ProjectModel(
      id: 'mcdonalds-dessert',
      title: "McDonald's Dessert Retouch",
      description:
          'Demo dessert cleanup with cream texture, color correction, wrapper cleanup, and bright commercial contrast.',
      category: 'Food',
      imageUrls: const [
        'https://images.unsplash.com/photo-1551024506-0bccd828d307?auto=format&fit=crop&w=1200&q=80',
      ],
      client: "McDonald's",
      date: '2024',
      order: 3,
    ),
    ProjectModel(
      id: 'demo-product-packshot',
      title: 'Cosmetics Packshot Polish',
      description:
          'Premium demo packshot edit with reflection cleanup, edge control, dust removal, and color consistency.',
      category: 'Product',
      imageUrls: const [
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=1200&q=80',
      ],
      client: 'Demo Brand',
      date: '2025',
      order: 4,
    ),
    ProjectModel(
      id: 'demo-fashion-editorial',
      title: 'Fashion Editorial Finish',
      description:
          'Natural skin work, fabric cleanup, tonal grading, and editorial-ready finishing with a clean premium look.',
      category: 'Fashion',
      imageUrls: const [
        'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=1200&q=80',
      ],
      client: 'Editorial Demo',
      date: '2025',
      order: 5,
    ),
  ];

  static final skills = <SkillModel>[
    SkillModel(
      id: 'dummy-photoshop',
      name: 'Adobe Photoshop',
      level: 95,
      category: 'Technical',
      order: 0,
    ),
    SkillModel(
      id: 'dummy-lightroom',
      name: 'Lightroom',
      level: 88,
      category: 'Technical',
      order: 1,
    ),
    SkillModel(
      id: 'dummy-capture-one',
      name: 'Capture One Pro',
      level: 86,
      category: 'Technical',
      order: 2,
    ),
    SkillModel(
      id: 'dummy-affinity',
      name: 'Affinity Photo',
      level: 80,
      category: 'Technical',
      order: 3,
    ),
    SkillModel(
      id: 'dummy-3dvista',
      name: '3D Vista',
      level: 78,
      category: 'Technical',
      order: 4,
    ),
    SkillModel(
      id: 'dummy-panels',
      name: 'Retouching Panels',
      level: 90,
      category: 'Technical',
      order: 5,
    ),
    SkillModel(
      id: 'dummy-team',
      name: 'Team Collaboration',
      level: 92,
      category: 'Soft Skills',
      order: 6,
    ),
    SkillModel(
      id: 'dummy-time',
      name: 'Time Management',
      level: 90,
      category: 'Soft Skills',
      order: 7,
    ),
    SkillModel(
      id: 'dummy-comms',
      name: 'Effective Communication',
      level: 86,
      category: 'Soft Skills',
      order: 8,
    ),
    SkillModel(
      id: 'dummy-leadership',
      name: 'Leadership',
      level: 88,
      category: 'Soft Skills',
      order: 9,
    ),
  ];
}
