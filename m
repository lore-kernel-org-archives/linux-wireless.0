Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36903 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbZKFSbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 13:31:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Martin Fuzzey <mfuzzey@gmail.com>
Subject: Re: b43: firmware loading problem and sleeping BUG
Date: Fri, 6 Nov 2009 19:31:13 +0100
Cc: linux-wireless@vger.kernel.org
References: <ba4215e10911060819y1175e003g695281fe084e07ab@mail.gmail.com> <200911061822.17121.mb@bu3sch.de> <ba4215e10911061027t413d2c34g8ad66a7982f7c43c@mail.gmail.com>
In-Reply-To: <ba4215e10911061027t413d2c34g8ad66a7982f7c43c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911061931.16509.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 November 2009 19:27:17 Martin Fuzzey wrote:
> [  109.690000] b43-phy0 ERROR: Firmware file "b43/pcm5.fw" format error.

> So any suggestions on figuring out what is going on?

Your userspace firmware helper (I guess it's not udev on your device?)
might be throwing crap at the kernel.

-- 
Greetings, Michael.
