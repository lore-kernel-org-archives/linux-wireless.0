Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppsw-8.csi.cam.ac.uk ([131.111.8.138]:42155 "EHLO
	ppsw-8.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYANNdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 08:33:25 -0500
Received: from ssnt2.quns.cam.ac.uk ([131.111.255.37]:50888 helo=neotoaster.lan)
	by ppsw-8.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.158]:25)
	with esmtpsa (PLAIN:ssnt2) (TLSv1:DHE-RSA-AES256-SHA:256)
	id 1JEPRE-0006lt-Se (Exim 4.67) for linux-wireless@vger.kernel.org
	(return-path <ssnt2@hermes.cam.ac.uk>); Mon, 14 Jan 2008 13:33:16 +0000
From: Shawn Tan <ssnt2@eng.cam.ac.uk>
Reply-To: ssnt2@eng.cam.ac.uk
To: linux-wireless@vger.kernel.org
Subject: Re: B43 problems
Date: Mon, 14 Jan 2008 13:33:15 +0000
References: <200801112059.45467.ssnt2@eng.cam.ac.uk>
In-Reply-To: <200801112059.45467.ssnt2@eng.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801141333.15740.ssnt2@eng.cam.ac.uk> (sfid-20080114_133329_673362_B31FC531)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 January 2008 20:59:45 Shawn Tan wrote:
> I've just successfully downloaded compat-wireless, compiled and loaded the
> latest B43 module. I can do iwlist scan and get an IP from my router. I can
> ping my router. However, the connection only lasts for a few seconds. Then,
> I need to re-associate again.

Hi,

Following my previous email, I changed some settings on my OpenWRT router and 
it seems to work flawlessly now. The error messages are all gone!!

I had to disable the "G-mode protection" in my router. Hope this information 
helps.

Thanks for the great job in bringing broadcom support to Linux!

cheers.

-- 
with metta,
Shawn Tan

Centre for Advanced Photonics and Electronics
Department of Engineering, University of Cambridge
9 JJ Thomson Avenue, Cambridge CB3 0FA, UK.
