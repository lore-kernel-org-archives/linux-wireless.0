Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35656 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab1LGVjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 16:39:33 -0500
Received: by ggnr5 with SMTP id r5so1106643ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 13:39:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323266001-12912-4-git-send-email-rmanohar@qca.qualcomm.com>
References: <1323266001-12912-1-git-send-email-rmanohar@qca.qualcomm.com> <1323266001-12912-4-git-send-email-rmanohar@qca.qualcomm.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 7 Dec 2011 13:39:12 -0800
Message-ID: <CAB=NE6VuhZ0B1cKfa6pQ0M9Bqo+Uwrcj2xcV74W0yENxfNHb7Q@mail.gmail.com> (sfid-20111207_223936_121251_D02201DF)
Subject: Re: [PATCH 4/4] ath9k: Reconfigure tx power on regulatory update
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 7, 2011 at 5:53 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> Whenever the regulatory got updated by country IE for the world
> roaming cards, need to reconfigure the tx power immediately to
> increase the power level.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

I ACK all except patch [3/4].

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis
