Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53080 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932963Ab1D1SMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 14:12:54 -0400
Received: by iwn34 with SMTP id 34so2442195iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 11:12:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 28 Apr 2011 11:12:33 -0700
Message-ID: <BANLkTi=8Vc5MGjK=K3=hkFLy=kiFy1osCg@mail.gmail.com> (sfid-20110428_201317_319369_CB9DC6F2)
Subject: Re: [RFC/RFT 0/9] ath9k: Add Antenna diversity support for AR9485
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Senthilkumar.Balasubramanian@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2011 at 7:22 AM, Mohammed Shafi Shajakhan
<mshajakhan@atheros.com> wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> *These are purely RFC/RFT patches, none of them are tested.
>  once tested we will send it as patches.
> *This patch set adds Antenna diversity support for AR9485, previously
>  antenna diversity is only supported in AR9285
> *The basic antenna diversity algorithm remains the same
> *slight change in the diversity field in eeprom
> *introduction of main/alt gain table and lna1_lna2 delta fields
> *initially set LNA1 for main antenna
> *introduction of diversity group
> *based on diversity group, fast diversity bias parmaters and
> lna1_lna2_delta varies
> *implement an API to take the decision of swapping main/ALT LNA's
> for AR9485
> *configure fast diversity bias based on diversity group

Apart from my one comment:

Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
