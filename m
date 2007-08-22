Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39458
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759820AbXHVWaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 18:30:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: ALERT: firmware change for b43
Date: Thu, 23 Aug 2007 00:28:48 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <46C89BF1.5060306@lwfinger.net> <20070822171805.GD2926@tuxdriver.com> <46CC7B89.7090906@lwfinger.net>
In-Reply-To: <46CC7B89.7090906@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200708230028.48464.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 August 2007 20:08:09 Larry Finger wrote:
> John W. Linville wrote:
> > On Wed, Aug 22, 2007 at 10:25:28AM -0500, Larry Finger wrote:
> >> John W. Linville wrote:
> >>> On Sun, Aug 19, 2007 at 02:37:21PM -0500, Larry Finger wrote:
> >>>> Just in case you missed the details, the latest set of changes to b43 
> >>>> queued by Michael will require
> >>>> a new version of fwcutter, now called b43-fwcutter, and a new extraction 
> >>>> of your firmware.
> >>> Is there a tarball available for download, as with bcm43xx-fwcutter?
> >>> It would be handy for packaging.
> >> The new code is in the svn repository; however, a tarball would not be a 
> >> problem. Is source sufficient, or would you want an executable?
> > 
> > Source would be fine, equivalent to what is here:
> > 
> > 	http://download.berlios.de/bcm43xx/bcm43xx-fwcutter-006.tar.bz2
> 
> I don't have nor want write access at berlios.de.  The file you want is:
> 
> ftp://lwfinger.dynalias.org/patches/b43-fwcutter-008.tar.bz2.
> 

http://prdownload.berlios.de/bcm43xx/b43-fwcutter-008.tar.bz2

Larry, please remove yours again, as it's not good to have multiple tarballs
with the same name/release version floating around

-- 
Greetings Michael.
