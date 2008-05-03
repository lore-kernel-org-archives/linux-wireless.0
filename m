Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:55154 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbYECSKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 14:10:32 -0400
Received: from peterson.fenrir.org.uk ([10.0.0.2])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JsMBp-0000Vr-Dv
	for <linux-wireless@vger.kernel.org>; Sat, 03 May 2008 19:10:29 +0100
Date: Sat, 3 May 2008 19:10:29 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
To: linux-wireless@vger.kernel.org
Subject: Re: Unexpected disassociations iwl3945 v1.2.25
Message-ID: <20080503191029.47e2d27e@peterson.fenrir.org.uk> (sfid-20080503_201028_003584_588D8C43)
In-Reply-To: <481C6864.40308@RoxSoft.co.uk>
References: <481C6864.40308@RoxSoft.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 03 May 2008 14:28:04 +0100
Peter Flanigan <pjf@RoxSoft.co.uk> wrote:

> As you know this driver replaced ipw3945 in the Ubuntu 8.04 LTS release. 
> It is  randomly disassociating connections on my IBM Thinkpad Z61m. 

Have you tried the compat-wireless packages? They update to the latest
wireless code and install the drivers in the updates sub-directory of
/lib/modules so that they are loaded in preference to the drivers from
the kernel package installed.

FWIW, the latest Fedora 8 kernel with 1.2.26 and much updated iwlwifi,
iwl3945 and mac80211 code is working very well for me when kernels from
a few weeks ago were not. Compat-wireless should get fairly close to
this if you can get it to build.

-- 

Brian Morrison

   "Arguing with an engineer is like wrestling with a pig in the mud;
    after a while you realize you are muddy and the pig is enjoying it."
