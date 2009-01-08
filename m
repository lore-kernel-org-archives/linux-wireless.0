Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:15375 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbZAHXPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 18:15:04 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3340983fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 15:15:02 -0800 (PST)
Message-ID: <3ace41890901081515xfed423ev2b873c69caffc0e4@mail.gmail.com> (sfid-20090109_001509_351757_18168CC2)
Date: Thu, 8 Jan 2009 23:15:02 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Rodrigo Fresneda" <fresneda@gmail.com>
Subject: Re: trouble with compat-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e6236e5f0901080730h49450037i862625f20e003897@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com>
	 <3ace41890901061536k7722b63h906962283ce9e4ad@mail.gmail.com>
	 <e6236e5f0901061740s20d817b1s2befb66cefbf72b0@mail.gmail.com>
	 <3ace41890901070440w63fbb06fy39e3bcb387f08d60@mail.gmail.com>
	 <e6236e5f0901080730h49450037i862625f20e003897@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2009 at 3:30 PM, Rodrigo Fresneda <fresneda@gmail.com> wrote:
> Hi, I wanted to thank you for trying to help me, and to let you know
> that I have given up compiling compat-wireless-old and have moved on
> to kernel 2.6.28, with which my
> wifi device works perfectly. It turns out that the amount of work I
> had to do to get my wifi on was a lot more that to fix my device
> issues with the latest kernel, so it simply wasn't worth it anymore.
> I was especially appalled to learn that the iwl drivers were broken in
> compat-wireless-old after 09/09/2008 and it has remained this way.
> rodrigo.

Glad to hear. I have since learned (from some exchanges on ndiswrapper
lists) that there were some major architectural changes in the intel
driver and the code probably had needed some time to stabilize. Thanks
for the patience and reporting back on the success with later kernels.

Good luck and enjoys the connectivity...
