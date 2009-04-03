Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:43106 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZDCQ6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 12:58:08 -0400
Received: by fk-out-0910.google.com with SMTP id 18so482444fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 09:58:05 -0700 (PDT)
Message-ID: <49D64018.3020804@gmail.com> (sfid-20090403_185814_850701_2B185CE5)
Date: Fri, 03 Apr 2009 18:58:00 +0200
From: Till Kamppeter <till.kamppeter@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org,
	Jussi Kukkonen <jku@linux.intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Dan Williams <dcbw@redhat.com>
Subject: Google Summer of Code 2009: Another wireless application
References: <68f4d6130903241108j590d49adj10446169f7c3c06b@mail.gmail.com> 	<43e72e890903241256l39f5b1f9i49ce2b7a6e8099c3@mail.gmail.com> 	<49CD0FCF.3060706@gmail.com> <43e72e890903271126p7a302460lffdd5cd8d6ebe807@mail.gmail.com>
In-Reply-To: <43e72e890903271126p7a302460lffdd5cd8d6ebe807@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we got another application on wireless. See below. Who has not done so
yet, do not forget to apply as mentor for the LF at 
http://socghop.appspot.com/.

    Till

--------------------

  Title:  	 AP mode support for Network Manager
Student: 	Witold Sowa
Mentor: 	No mentor assigned
Possible Mentors: 	None
Abstract:
Since the 2.6.29 version, Linux kernel supports the Access Point mode 
for mac80211 drivers. However, there is no simple GUI tools available, 
which would let users set their own AP easily. This project purpose is 
to add the AP mode support to NetworkManager using hostapd or 
wpa_supplicant. That will require creating a suitable dbus interface for 
hostapd or moving hostapd's functionality to wpa_supplicant. GUI tools 
for managing the Access Point mode will be delivered too.
Content:
Personal information

My name is Witold Sowa and I am a fourth year student of computer 
science at AGH University of Science and Technology in Cracow, Poland. I 
am interested in networking and systems based on wire and wireless 
communications, especially in solutions for mobile devices and i am 
going to concentrate my further education on these issues. I am 
convinced that my current knowledge and experience gained during 
realization of many student's and private projects as well as during 
last summer internships in Motorola Poland Software Center will let me 
realize my Google Summer of Code project with outstanding result.
Technical skills and setup

I use an Acer notebook with 32-bit Intel Celeron M CPU, and Atheros 
AR2413 Mini-PCI wireless NIC running under control of OpenSUSE 11.1 
Linux distribution. I am going to supply myself with another wireless 
NIC which will use kernel mac80211 driver soon. First two years of my 
studies I was coding mainly in C/C++ using many types of third-party 
libraries like scientific, multimedia, or networking and of course 
standard library including STL. During my internship in Motorola I was 
programming using Perl and Python, which became my favorite language. My 
job was preparing and integrating components of automated testing 
environment for network devices. I have some basic knowledge about 
802.11 standards, which I hope extend during realization of my project. 
Unfortunately, I have just started my first project connected with 
kernel development at my studies which will concern DCCP protocol, so my 
experience in this matter is rather minimal but the project I am 
applying for doesn't require kernel code modifications. I have also some 
experience with Java. Because of of my private project which is a 
hovercraft model controlled using a Bluetooth enabled cell phone, I have 
a practical knowledge in programming for Atmel micro controllers in C 
and for mobile devices in JavaME. Besides mentioned C/C++, Python, Perl 
and Java, I also have an experience in following programing languages 
and techniques: XML-RPC, RPC, Java RMI, CORBA, XML, JavaScript, UML 
modelling, unit tests, shell scripting, Qt framework, C#. I was 
repeatedly working with Subversion and once with Mercurial and Git
Cooperation with linux-wireless group

My experience in open source development is mainly limited to KDE 
project. I sent a few patches to KDE applications and I was working in 
already dead project QuickAccess concerned with KDE4 GUI. Since I have 
never participated in any linux-wireless group project, I believe that 
realization of my GSoC project would be a very good beginning. It is 
extremely important to me to feel that effects of my work will be 
helpful for many people. I am sure that thanks to my work Linux users 
will be able to set up theirs own Access Points much more easily.
My project

I am going to write clean, separated into 3 layers, tested and well 
documented code and keep it as simple as possible. I have chosen Access 
Point support for Network Manager project to carry on because it will 
let Linux users make better use of kernel capabilities and it concerns 
area of my interests, e.i. networking and wireless communication. I 
think that I am suitable candidate to carry on that project because my 
technical knowledge, experience and will to learn combined with high 
motivation will let me carry out my ideas with all details. I am going 
to invest at least 40 hours per week of my time except one week in the 
middle of June (20-30h/week) when I will have to spend more time on my 
studies projects. Of course, I will make up for the lost time in next 
weeks and I will make an effort to keep up with the schedule. Since I 
treat Google Summer of Code as a beginning of cooperation with Linux 
wireless community, I am going to contribute to group's work after 
finishing the project during academic year investing at least few hours 
per week.
Preliminary schedule

    1. Before the beginning of program I am going to familiarize myself 
better with source code of hostapd, wpa_supplicant and NetworkManager. I 
will also discuss implementation details on linux-wireless list, 
especially with Dan Williams who would be my mentor. Probably, I will 
also try to perform some experiments with mentioned source codes.
    2. I estimate that making required changes in hostapd code or moving 
its functionality to wpa_supplicant will be the most time consuming part 
of the project and it should be finished till end of June. The changes 
would be creating dbus interface used to control hostapd and moving most 
of its configuration options from configuration file to dbus interface.
    3. Then, I would spend whole July on hacking on NetworkManager. 
Making it communicating with altered hostapd/wpa_supplicant will take 
about half of the month. The second half will be spend on creating NM's 
dbus interface for client applications like nm-applet.
    4. Making GUI for nm-applet will take first week of August.
    5. The rest of the project's time and some time after the deadline 
if necessary, I will spend on final testing, cleaning and refactoring 
the code as well as on updating code's documentation.

