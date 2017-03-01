Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61313 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbdCAOak (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 09:30:40 -0500
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Gery Kahn <gery.kahn@broadcom.com>, Jouni Malinen <j@w1.fi>
Subject: Re: FILS offloading
Date: Wed, 1 Mar 2017 14:30:34 +0000
Message-ID: <20170301143032.GB11544@jouni.qca.qualcomm.com> (sfid-20170301_153226_296540_328FB09B)
References: <d4fb8ca8-9632-3154-488e-5d7232601ed6@broadcom.com>
In-Reply-To: <d4fb8ca8-9632-3154-488e-5d7232601ed6@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 01, 2017 at 11:28:48AM +0100, Arend Van Spriel wrote:
> Not sure which email address to use ;-) I noticed a while ago that FILS
> offloading was on the agenda of wireless workshop in Santa Fe. Recently,
> looked at the FILS patches that were applied upstream and noticed:

> static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rd=
ev,

> 	case NL80211_CMD_CONNECT:
> 	case NL80211_CMD_START_AP:
> 		/* FILS not supported yet */
..

> Are there any plans on QCA side to add FILS support for fullmac devices,
> ie. supporting CONNECT command.

We do indeed have a patch going through internal review for this (well,
for the station part NL80211_CMD_CONNECT, not _START_AP). I hope to get
that posted shortly for public review.

--=20
Jouni Malinen                                            PGP id EFC895FA=
