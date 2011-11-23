Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab1KWPsj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:48:39 -0500
Date: Wed, 23 Nov 2011 16:51:09 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jan =?utf-8?B?RHZvxZnDoWs=?= <dvorakj@cngroup.dk>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu not working with Edimax EW-7811Un
Message-ID: <20111123155108.GD13460@redhat.com> (sfid-20111123_164842_374579_2B052E51)
References: <20111122113427.3d332b00776546d5ebac11de@cngroup.dk>
 <20111122140139.GA3891@redhat.com>
 <20111123112301.f5e523ff743f86dae539fdf3@cngroup.dk>
 <20111123143304.GA13460@redhat.com>
 <20111123162426.9a30d25585fa54507c1c864e@cngroup.dk>
 <4ECD13D0.6010500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4ECD13D0.6010500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 23, 2011 at 09:40:00AM -0600, Larry Finger wrote:
> On 11/23/2011 09:24 AM, Jan Dvořák wrote:
> >>http://koji.fedoraproject.org/koji/taskinfo?taskID=3534603
> >
> >OK, I have no idea if this is because of the new kernel, but
> >client mode works.
Could you confirm that on previous kernel client mode does not
work, and work with that new kernel?  

> I can't still use hostapd, however.
Hmm, I'm not sure if rtl92c works in AP mode, Larry?

> >So, in hope this does not get old too soon, any ideas? :-)
Eeee..., I do not understed this question.

> What patches did you put in that koji kernel?

Full revert of:

commit b23b025fe246f3acc2988eb6d400df34c27cb8ae
Author: Ben Greear <greearb@candelatech.com>
Date:   Fri Feb 4 11:54:17 2011 -0800

    mac80211: Optimize scans on current operating channel.

> I know that the initial driver had a problem connecting to
> 802.11n-only channels, but this was fixed in wireless-testing some
> time ago. Is this the patch?
No.

Thanks
Stanislaw
