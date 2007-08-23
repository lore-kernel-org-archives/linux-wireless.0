Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:57373
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbXHWU70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 16:59:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: ALERT: firmware change for b43
Date: Thu, 23 Aug 2007 22:57:41 +0200
Cc: David Woodhouse <dwmw2@infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <46C89BF1.5060306@lwfinger.net> <1187860330.22432.139.camel@pmac.infradead.org>
In-Reply-To: <1187860330.22432.139.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708232257.42291.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 August 2007 11:12:10 David Woodhouse wrote:
> On Sun, 2007-08-19 at 14:37 -0500, Larry Finger wrote:
> > It is recommended that you update fwcutter before these patches are
> > merged. If your version of fwcutter was obtained with subversion, a
> > simple 'svn update' in the fwcutter directory will suffice.
> > If you are using a version provided by your distro, you will need to
> > checkout the latest version with the command 'svn checkout
> > svn://svn.berlios.de/bcm43xx/trunk/fwcutter'. 
> 
> Ew, Subversion. Hasn't everyone abandoned that yet?
> 
> I've set up a script to mirror it into git hourly:
> 	http://git.infradead.org/?p=b43-fwcutter.git
> 	git://git.infradead.org/b43-fwcutter.git
> 

Well, for most of my projects. But I didn't see a really good
reason to move fwcutter to git, yet.
Maybe I should move it to git, though, as git trees are easier to handle.

-- 
Greetings Michael.
