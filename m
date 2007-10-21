Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33803
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXJURfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 13:35:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: reading/writing zd1211 eeprom
Date: Sun, 21 Oct 2007 18:58:57 +0200
Cc: kune@deine-taler.de, linux-wireless@vger.kernel.org
References: <200710211335.39373.mb@bu3sch.de> <471B7B0C.5090900@gentoo.org>
In-Reply-To: <471B7B0C.5090900@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710211858.58020.mb@bu3sch.de> (sfid-20071021_183551_632627_37297F9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 October 2007 18:15:08 Daniel Drake wrote:
> Michael Buesch wrote:
> > I'd like to read/modify the eeprom of my zd stick.
> > Do you have software to do so? If not, any advice on how
> > this has to be done? I'd write the necessary driver patches,
> > if you just tell me how the eeprom is accessed.
> 
> Yep, zd1211memtool.
> 
> http://sourceforge.net/project/showfiles.php?group_id=129083&package_id=238745
> 
> Usual precautions apply: you could easily break your device, and this 
> code isn't very widely tested (but it works for me).

Nice, thanks.

Do you also have this in some git repository?

-- 
Greetings Michael.
