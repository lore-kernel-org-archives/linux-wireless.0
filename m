Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19179 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZAZRbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 12:31:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 09:31:45 -0800
Date: Mon, 26 Jan 2009 09:31:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: do not pass -EALREADY to userspace on
	regdomain  change request
Message-ID: <20090126173105.GA19242@tesla> (sfid-20090126_183201_459794_428D61C9)
References: <1232989251-21311-1-git-send-email-lrodriguez@atheros.com> <69e28c910901260927uaeedb6fpd8b14c7f93f51a80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910901260927uaeedb6fpd8b14c7f93f51a80@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2009 at 09:27:37AM -0800, G=E1bor Stefanik wrote:
> On Mon, Jan 26, 2009 at 6:00 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > +        * we don't want to confuse userspace with a "successfull e=
rror"
>=20
> Typo.

successful, thanks.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
