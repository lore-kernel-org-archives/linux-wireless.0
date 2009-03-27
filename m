Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65354 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZC0Rlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 13:41:42 -0400
Received: by fxm2 with SMTP id 2so1127630fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 10:41:39 -0700 (PDT)
Message-ID: <49CD0FCF.3060706@gmail.com> (sfid-20090327_184147_642557_4ED04E76)
Date: Fri, 27 Mar 2009 18:41:35 +0100
From: Till Kamppeter <till.kamppeter@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Jussi Kukkonen <jku@linux.intel.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: GSoC '09 applicant : Introduction
References: <68f4d6130903241108j590d49adj10446169f7c3c06b@mail.gmail.com> <43e72e890903241256l39f5b1f9i49ce2b7a6e8099c3@mail.gmail.com>
In-Reply-To: <43e72e890903241256l39f5b1f9i49ce2b7a6e8099c3@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalpana Roy has now applied officially for his project. To get access to 
the application, add comments and ratings and also to add yourself as a 
mentor for him, you must at first apply for being a mentor for the Linux 
Foundation. Go to http://socghop.appspot.com/, log in with your Google 
account (create one if you have none), fill in your profile and apply 
for being a mentor for the Linux Foundation (link ID of the Linux 
Foundation is "LF"). I will approve you as mentor and then you will be 
asked to fill in your mentor profile after having done so, you get 
official mentor (but not yet assigned to any student) and will have 
access to the application.

For simply reading the application I add it below.

    Till

Luis R. Rodriguez wrote:
> On Tue, Mar 24, 2009 at 11:08 AM, k roy <kroykroy@gmail.com> wrote:
>> Hello,
>>
>> I guess that I am pretty late at introducing myself in this mailing
>> list but I will do it nevertheless. My name is Kalpana Roy, a final
>> year student from India, pursuing her B.Tech(I.T.) degree. Inspite of

[...]

-----------------------------------------------------------------------------

Title:  	 Integrate Geoclue with Gnome-desktop and to help with 
regulatory compliance
Student: 	Kalpana Roy


Abstract:
---------

The current project aims to incorporate the location-awareness in the 
Gnome-desktop and utilise the same to automatically update the linux 
kernel to set the country for the current regulatory domain. It will 
comprise of 2 parts:
1.Integrating Clock & weather applet, Tracker, Evolution, Empathy and 
Gwibber with automatic location sensitivity.
2.Extending Network Manager to seed to wpa_supplicant, the country which 
should be set for the regulatory implementation, which in turn passes it 
to the kernel.


Content:
--------

What is the ultimate goal of your proposal? What do you want to achieve?

The project plans to achieve the following two goals :

    1.

       incorporate the location-awareness in the Gnome-desktop by 
integrating the automatic location sensitivity into various 
Gnome-desktop applications, and,
    2.

       utilise the location-awareness to automatically update the linux 
kernel to set the country for the current regulatory domain.

The geographical information will be treated along the same lines as 
time and hence automatic updation or manual modification of the location 
will be as easy as changing time or date.
What components/modules will it touch/change or create?

In order to achieve the afore-mentioned goals, the project will utilise 
the set of geoinformation APIs provided by GeoClue, and the providers 
which implement these APIs. With the help of these, we will get position 
information, get location coordinates through address (Geocode) and find 
address with the help of location coordinates (Reverse Geocode).

     *

       As the first step towards making the Gnome-desktop location 
aware, the following Gnome applications will be integrated with GeoClue 
services : Clock and weather applet, Tracker, Evolution, Empathy and 
Gwibber. (Although there are many other Gnome applications which can be 
integrated with GeoClue, but keeping the GSoC time frame in mind, the 
work is restricted to these applications only, for now. The other 
applications are planned to be added with location sensitivity feature, 
after successful completion of the proposed work). [Optional] Also, for 
the Internet-based applications, a map can be generated to view the 
location of the contacts in the visual format, using OpenStreetMap and 
libchamplain.
     *

       The second part of the project will be implemented by extending 
Network Manager to make use of the information supplied by GeoClue to be 
able to seed the country which should be set for the current regulatory 
domain, to wpa_supplicant, which in turn passes the information to the 
linux-kernel.

What benefits does it have for the community?

The project aims to make Gnome-desktop *smarter*, in the sense that it 
can automatically sense/realise the location/place where its computer 
system is. A computer system can automatically update its time, if the 
timezone is set. Both geographical location as well as time, are 
informations which human beings refer from their environment or context. 
This comes naturally to the human beings and gives them the smartness or 
intelligence and the edge over the computers. If a computer can infer 
its geographical location as well, then it will be one step closer to 
being more human-like or achieving human intelligence.
The following usecases will illustrate how the project proposal is 
beneficial for users  :

    1.

       The proposed functionality is new and not provided by any other 
desktop environment or operating system. Hence, Gnome will be more 
user-friendly by providing this one-of-a-kind functionality.
    2.

       Give the gnome users the ease of not manually changing the time 
and weather settings everytime they move from one place to another.
    3.

       Clock can not only automatically update the time & weather 
settings but also display the appointments/tasks specific to a location.
    4.

       The Tracker will index the files based not only on time but also 
on the basis of location of access/modification, then users can place 
queries in the form "Show the files which I edited in Stockholm".
    5.

       Allow the users to set instant messaging availability status 
based on location ("Set my work account as offline when I'm home").
    6.

       Make Gwibber send the current location of the user to 
microblogging services that support it (like brighkite).

As stated above this project has two parts, and it will be done under 
the co-mentorship of Gnome and Linux Foundations, both selected for GSoC 
'09. The second part of the project focuses on the new regulatory 
implementation for Linux wireless which features a new regulatory 
infrastructure starting from the 2.6.28 kernel. Devices can specify 
their regulatory domain through different interfaces and users can 
further help compliance by specifying their country. So the best way of 
achieving this is , instead of users having to manually supply the 
location, GeoClue services are utilised by Network Manager which gets 
the country value and sends the ISO 3166-1 alpha-2 country code to the 
kernel via wpa_supplicant. Hence this automation will help in 
maintaining the regulatory compliance with a greater ease.
Why you'd like to complete this particular project? If you have chosen 
an idea from our list, why did you choose this specific idea?

The project proposal is a combination of ideas listed by Gnome and Linux 
Foundations for GSoC '09. Both the ideas listed the use of 
GeoClue/location awareness and hence the ideas were combined. While 
scanning through the ideas list of Gnome, I preferred to choose a 
project which would be suit my technical knowledge and allow me to 
complete it successfully. The idea of location awareness appealed to me 
the most and it also matched with my technical knowledge and experience. 
I could immediately relate to the various benefits that could be 
achieved if the desktop applications had location awareness; the various 
small automations and ease which would be supported through the project 
while working on mobile computer systems.

I chose to apply in GSoC so that I can get into FOSS development and not 
just looking for a summer job opportunity. I own a laptop and have to 
travel from my college to my home everyday and hence I could absolutely 
relate myself to the benefits that would be achieved by making the Gnome 
desktop location aware. The reason for choosing Gnome is very simple, I 
work on Linux machines mostly and Gnome has been my desktop environment 
of choice since I started using Linux, so I wanted to work on something 
which could be ultimately used by me.
Another reason for choosing and sticking with this project were the 
immediate and encouraging responses which I received on the mailing list 
and IRC channel. GeoClue developers Jussi Kukkonen and Henri Bergius 
helped me in developing the ideas list to what it is now and satisfing 
my queries. They made me understand the depth of the work involved in 
the project and not underestimate as building a "few patches for random 
applications". Luis Rodriguez from Linux Foundations (who has very 
kindly agreed to co-mentor this project, in case of being selected), 
made me aware about the idea of integrating Geoclue to maintain the new 
regulatory compliance. This is how the current project proposal came to 
be what it is now and combining the two similar ideas has helped me to 
scale the work big enough to be completed in the given time frame and 
also exciting enough to work on.
Why do you think you are the best person to work on this project? What 
makes you suited to carry out the project?

I chose this project to apply for GSoC '09 for the reasons that, 1. I 
possessed the basic technical knowledge which is required to be able to 
work on it, 2. I found the idea extremely interesting, innovative and 
useful. The idea gave me the vision to imagine the computers more 
knowledgable and intelligent than before. I feel that it is very 
important to enjoy the project that you are going to work on and I 
definitely feel excited about this one. This project will satisfy both 
my hunger to contribute to open-source as well as fulfill my creative 
aptitude. I am not a programmer who sticks to traditional terms of ~6 
hours of work a day; I can work continuously for days if the work 
demands and is interesting and hence I feel that I can contribute to 
this project a lot more than the others. I plan to continue the work 
after GSoC ends as well. I guess having developed the project to what it 
is now from the idea of the clock applet automatically detecting 
timezone changes, shows my dedication to the project and also the fact 
that I have done research about the same and contacted the developers to 
let them know about my idea and my willingness to work and make 
location-awareness a reality.
How much time do you plan to invest in the project before, during and 
after the Summer of Code (We expect full time 40h/week during GSoC, but 
better make this explicit)?

I plan to start working on the project from April itself and would spend 
the month learning more about the technologies to be used. From May to 
August, which will be the coding months, I can devote full time working 
on the project as there are no prior committments which can take up my 
time. As already stated, I am planning to include location senstivity to 
the Gnome applications which will not be covered in the GSoC period so 
my committments to this project stay even after GSoC. Also, I will look 
into improving/alternate ways of passing the location information to 
kernel for regualtory compliance after GSoC.
How do you plan to achieve completion of your project?

I plan to complete the project by dividing the whole work into modules 
and creating deadlines for their completion. The preliminary timeline 
includes :

     *

       April : Study the source code and get familiar with the various 
technologies and applications to be used in the project (GeoClue, Clock 
and weather applet, Tracker, Evolution, Empathy, Gwibber, Network 
Manager). Write a patch for GeoClue to fix a bug OR to complete some of 
the TODOs listed. Learn more about the new regulatory infrastructure of 
the linux kernel.
     *

       May - June : Create Geoclue patches for the gnome applications to 
enable location sensitivity. Starting with Clock (ensure timezone 
detection and change , weather change according to location, 
appointments/tasks display according to location), will move to the 
Internet based applications Gwibber, Evolution and Empathy to update 
them with location information, and then will add the functionality of 
indexing based on location to Tracker. [Optional] Also look into the 
generation of maps of the locality using OpenStreetMap and libchamplain 
for use along with the Internet based applications, depending on the 
time left.

Plan to complete making Gnome-desktop location aware before mid-term 
evaluation.

     *

       July : Add the functionality of finding the country of location 
to Network Manager and sending the code to Wi Fi protected acces 
supplicant to be sent to the kernel for implementing regulatory complaince.
     *

       August : Integrating together all the functionalities developed 
and checking for loop-holes/glitches.

What are your past experiences (if any) with the open source world?

I have been using free & open source softwares since the times I had a 
personal computer but was introduced to contributing to FOSS, last year 
through a successful GSoC '08 student. I understood and appreciated FOSS 
movement since then and was willing to contribute to it. The projects 
which I had worked on throught out my college life used open source 
technologies although my first shot at *real* open source development 
was the developing a GUI for VPython using PyGtk. I also submitted 
patches for additional functionalities to an already existing VPython 
editor but the author had not released/maintained the editor officially 
hence, I cannot claim that my work was included in VPython officially. 
The desire to contribute to open-source and finding ways of doing so are 
the sole reasons which have driven me to GSoC and through the program I 
have finally known the ways of contributing to FOSS.

My current project, which will finish by the end of April, is the use of 
distributed fast fourier transform for writing fully distributed N-body 
code for cosmological applications. It is also an open-source project 
which uses C language, FFTW and MPI(Message Passing Interface) libraries 
and is useful for astro-physics calculations.
Biography :

I am Kalpana Roy, a final year student at Indian Institute of 
Information Technology, Allahabad, India, pursuing my B.Tech (I.T.) 
degree. After being a FOSS user for a long time, I have come to 
appreciate the FOSS movement and want to contribute to its development. 
Google Summer of Code is the first official step towards it and I am 
extremely enthusiastic and motivated to participate. I usually code in 
C++ and am familiar with C, Java, PHP, MySql, Python (mostly VPython & 
PyGtk) and Bash. Some of my major projects include creating an FTP 
server searcher, ICE - Integrated Conference Environment (software 
similar to OpnConf), Document Similarity Analyser, VPython GUI/Editor 
and Using distributed systems for generating N-body codes. Though I have 
always used open source softwares and developed open source softwares, I 
have never been involved in contribution to already existing open source 
organisations and programs and hence I am looking forward to do so 
through GSoC '09.
I am among the toppers of my batch and regular recepient of college 
scholarships. I was associated with the STL (Standard Template Library) 
teaching group of my college and was also the team leader of the college 
team participating in Google Got the 'App'titude Challenge. My 
extracurricular interests include solving online riddles, for which I 
have won many college level competitions, watching animes and reading 
mangas. I have been placed in Adobe Systems, India which I will be 
joining after the completion of my B.Tech course, later this year. I 
want to start and continue contributing to FOSS and spread the word 
around to motivate more people like me who had always harbored a wish to 
contribute but never knew how.

Additional info: 
http://wireless.kernel.org/en/developers/GSoC/2009/GeoClue_regulatory

Created on: 	2009-03-27 11:46:41.183111
Last Modified on: 	2009-03-27 11:50:34.039773
