Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f187.google.com ([209.85.211.187]:51453 "EHLO
	mail-yw0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0FDSEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 14:04:25 -0400
Received: by ywh17 with SMTP id 17so794113ywh.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 11:04:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C092155.5040206@openwrt.org>
References: <4BEC2318.5050701@create-net.org>
	<AANLkTimnzAJd9Y02m8OBVLHphL5pbFw56M2LfB1L5oKz@mail.gmail.com>
	<4BEE684F.2070707@create-net.org>
	<loom.20100604T153747-904@post.gmane.org>
	<4C09151C.7040509@openwrt.org>
	<AANLkTik03jIq7xEzdY0FF3LQHI_Zqeu_unbI3CJbUqu-@mail.gmail.com>
	<4C092155.5040206@openwrt.org>
Date: Fri, 4 Jun 2010 19:36:19 +0200
Message-ID: <AANLkTikmBtf3iqVleTGvee3ugM00wlte14abC9tOKFFH@mail.gmail.com>
Subject: Re: Strange ACK Behaviour with ath9k
From: Roberto Riggio <roberto.riggio@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Did you test a recent version of wireless-testing/compat-wireless?
> IIRC versions before the AR9300 merge had some bugs/inconsistencies in
> the fast clock handling for 5 GHz.

I'm using compat wireless 2010-05-24 (the version available in openwrt trunk).

> - Felix
R.
