Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbbCGFhc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 00:37:32 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/1] New driver: rtl8723au (mac80211)
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
	<54FA3D9E.40107@lwfinger.net>
	<wrfj385hwfbu.fsf@ultrasam.lan.trained-monkey.org>
	<1425706383.16721.2.camel@perches.com>
Date: Sat, 07 Mar 2015 00:37:22 -0500
In-Reply-To: <1425706383.16721.2.camel@perches.com> (Joe Perches's message of
	"Fri, 06 Mar 2015 21:33:03 -0800")
Message-ID: <wrfja8zpv04t.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150307_063735_545398_815631F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Sat, 2015-03-07 at 00:23 -0500, Jes Sorensen wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> > I also
>> > think that this code should be placed in a separate sub directory
>> > under drivers/net/wireless. 
> []
>> If the code grows substantially, we can
>> move it into a sub directory, but for now I think it's fine to keep it
>> as is.
>
> Please use a separate directory instead.

As long as the driver consists of 3 files, there is zero reason to move
it into a separate directory.

Jes
