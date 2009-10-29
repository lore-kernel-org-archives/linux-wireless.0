Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23102.mail.ird.yahoo.com ([217.146.189.42]:20455 "HELO
	web23102.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751739AbZJ2HIr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 03:08:47 -0400
Message-ID: <984452.43367.qm@web23102.mail.ird.yahoo.com>
Date: Thu, 29 Oct 2009 07:08:50 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: LinuxUSB_AR2524-3.0.0.56_2009May_pathset
To: daniel.schmitt@udo.edu
Cc: zd1211-devs@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <375b18c40b54ff9adc56af39431b864e.squirrel@unimail.uni-dortmund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 29/10/09, Daniel Schmitt <daniel.schmitt@udo.edu> wrote:

> Hello Hin-Tak,
> 
> this URL does not work either:
> http://htl10.users.sourceforge.net/LinuxUSB_AR2524-3.0.0.56_2009May_pathset/
> 
> Can you please mail me a .tar.bz-archive of the patches you
> did for the
> ZD1211 3.00 Vendor driver?
> I want to get AP mode running and this doesn't work with
> zd1211rw driver.
> 
> Thanks,
> Daniel
> 
> 

Sorry, I moved it slightly:
http://htl10.users.sourceforge.net/patchsets/LinuxUSB_AR2524-3.0.0.56/

and withdrawn patch 04 (which I inherit from somebody), which seems to be not needed and breaks 64-bit platform; there were also two new patches which ports it forward to 2.6.30/2.6.31 since I last wrote.


      
