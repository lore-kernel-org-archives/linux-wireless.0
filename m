Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57320 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826AbXHWWQ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:16:56 -0400
Message-ID: <46CE0757.8000008@lwfinger.net>
Date: Thu, 23 Aug 2007 17:16:55 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: ALERT: firmware change for b43
References: <46C89BF1.5060306@lwfinger.net> <1187860330.22432.139.camel@pmac.infradead.org>
In-Reply-To: <1187860330.22432.139.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Woodhouse wrote:
> On Sun, 2007-08-19 at 14:37 -0500, Larry Finger wrote:
>> It is recommended that you update fwcutter before these patches are
>> merged. If your version of fwcutter was obtained with subversion, a
>> simple 'svn update' in the fwcutter directory will suffice.
>> If you are using a version provided by your distro, you will need to
>> checkout the latest version with the command 'svn checkout
>> svn://svn.berlios.de/bcm43xx/trunk/fwcutter'. 
> 
> Ew, Subversion. Hasn't everyone abandoned that yet?
> 
> I've set up a script to mirror it into git hourly:
> 	http://git.infradead.org/?p=b43-fwcutter.git
> 	git://git.infradead.org/b43-fwcutter.git
> 

Although git is clearly superior, it doesn't make that much difference for small projects. Where 
Subversion still has a place, however, is where the project is code used on multiple OS's. At least 
I haven't seen a port of git to Windows. OS X wouldn't be that much trouble, I guess.

Larry
