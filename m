Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58584 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935366AbZDCSAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 14:00:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1LpngR-0004HC-7h
	for linux-wireless@vger.kernel.org; Fri, 03 Apr 2009 18:00:03 +0000
Received: from c-24-23-162-22.hsd1.ca.comcast.net ([24.23.162.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 18:00:03 +0000
Received: from ashwinraut2004 by c-24-23-162-22.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 03 Apr 2009 18:00:03 +0000
To: linux-wireless@vger.kernel.org
From: Ashwin Raut <ashwinraut2004@yahoo.com>
Subject: Application for Linux Wireless GSoC 2009 Project
Date: Fri, 3 Apr 2009 17:55:00 +0000 (UTC)
Message-ID: <loom.20090403T175417-139@post.gmane.org> (sfid-20090403_200013_526048_642D769B)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To
The Mentors     =20
Improving Wireless Roaming                                             =
    =20
Linux Wireless GSoC 2009
Linux Foundation.

Sub:  Application for Linux Wireless GSoC 2009 Project.=20

Hi my name is Ashwin Raut. I am currently pursuing my Masters degree at=
 San=20
Jose State University, San Jose, CA,USA in Computer Engineering with Em=
bedded=20
Systems as my specialization. I have done my Bachelors in Electronics a=
nd=20
Telecommunication Engineering.

I am applying to work for the Linux Foundation Google Summer of Code 20=
09=20
project Improving Linux Wireless roaming which involves implementing tr=
iggers=20
for efficient AP handoffs.

Project Idea:

What I think of it is that one way of implementing this is to improve t=
he=20
present background scanning mechanism by making it periodically active.=
 That is=20
the RSSI beacon scan will take place after a specific interval of time =
say=20
around 200 ms and based on this , the information of the strongest sign=
al AP=E2=80=99s=20
can be collected by profiling the signal strengths from AP=E2=80=99s. S=
o that over a=20
period of time only those AP=E2=80=99s will be scanned that provide goo=
d signal=20
strength which is above the predetermined threshold level. If there is=20
possibility that no AP provides signal strength above the predetermined=
=20
threshold then the scanning will be made broader. This will help in dec=
iding=20
the next best AP to connect to if the signal strength of existing AP is=
=20
degrading over period of time. So either user can decide what to do or =
that=20
functionality can also be provided in algorithm. Now this type of activ=
e=20
scanning can reduce the overheads taking place in continuous scanning.
The triggering mechanism will use the above information and decide when=
 to=20
switch between Access points. There are two important points in this, f=
irst the=20
triggering will take place only when the signal strength of the current=
 AP is=20
degrading over a period of time specified by us or if the signal streng=
th=20
suddenly goes below the signal threshold level, and secondly we can als=
o=20
consider the AP selection based on the traffic load on that AP=E2=80=99=
s as one of the=20
AP determining factors.
I would like to implement it mainly in C++ but use any other language l=
ike C,=20
Python as substitute or along with it is ok with me.

My Background details:
I use x86 hardware Architecture with Fedora 9 as Operating system as we=
ll as=20
Windows Vista. I use C and C++ for coding. Presently, I am working as r=
esearch=20
assistant in my university where my principle role is to implement TDMA=
 MAC=20
Layer in Software Defined Radio i.e GNU Radio with USRP hardware. Here =
I am=20
implementing MAC layer Functionality in Click Modular router in C++ and=
 the=20
wrapping it with Python to port it to GNU Radio in Fedora 9.I am also s=
urveying=20
various MAC layers and localization techniques used in Wireless Sensor=20
Networks. I am familiar with working on Linux character Device Drivers =
and=20
porting Linux on ARM based embedded systems as that=E2=80=99s part of m=
y degree=20
specialization.

I would like to work on this project as this will give me a great oppor=
tunity=20
to work on an Open Source project and apply my skills to contribute in =
its=20
development .

I would be available to work full time from 27 th march 2009 as soon as=
 I=20
finish my final exams. I would also like to know more about this projec=
t and=20
the application procedure.
Please let me know if you need more information.I am very sorry for bei=
ng so=20
late.

Regards,
Ashwin Raut=20
MS Computer Engineering,
San Jose State University,
San Jose, CA, USA.                                            =20
Email: ashwinraut2004@yahoo.com





--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
