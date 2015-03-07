Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:34382 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752673AbbCGFlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 00:41:02 -0500
Message-ID: <1425706858.16901.1.camel@perches.com> (sfid-20150307_064106_914508_251C3A63)
Subject: Re: [PATCH 0/1] New driver: rtl8723au (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Date: Fri, 06 Mar 2015 21:40:58 -0800
In-Reply-To: <wrfja8zpv04t.fsf@ultrasam.lan.trained-monkey.org>
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
	 <54FA3D9E.40107@lwfinger.net>
	 <wrfj385hwfbu.fsf@ultrasam.lan.trained-monkey.org>
	 <1425706383.16721.2.camel@perches.com>
	 <wrfja8zpv04t.fsf@ultrasam.lan.trained-monkey.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-03-07 at 00:37 -0500, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > On Sat, 2015-03-07 at 00:23 -0500, Jes Sorense wrote:
> >> Larry Finger <Larry.Finger@lwfinger.net> writes:
> >> > I also
> >> > think that this code should be placed in a separate sub directory
> >> > under drivers/net/wireless. 
> > []
> >> If the code grows substantially, we can
> >> move it into a sub directory, but for now I think it's fine to keep it
> >> as is.
> >
> > Please use a separate directory instead.
> 
> As long as the driver consists of 3 files, there is zero reason to move
> it into a separate directory.

I think you discount that separation is good.

cheers, Joe

