Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDDFEB64DA
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 08:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243524AbjFNI3J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 04:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbjFNI3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 04:29:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2A3CA
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 01:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=e162f01dz0nSzdMkqRrqnVF/Q4/MgvAvsSuNb8DbCrc=;
        t=1686731343; x=1687940943; b=Tf6ifRCH02GeXNKaAhDhAx+szzomTYW5CCWfsZjtvGAj2UC
        XnQiS5mxTsjqFpOV2eRsNthFXNDsH87Jsy3UfCW6GDr2AhDU3TiE+HkEc+GKRFg4Zyrik+HXIQjDP
        uET7ReBajqww+AyKErIcMqWmcV6BSshnImfxStwqRODWpNXCzm5G/xr0MXT06m9QjiHdGhuau1rHH
        q5ZsfQ3t8MwsIKwEsXxYdB0R51YvksyMoYrNFvId+s+JspO5KM7iegkzYWDq3vGXP9Dj5d7R+fToU
        wBMN8GQ5NyrZVFi0A1DffMJ+FBCsSuQj/HHeTRe1ggZwcfwqQ9ymRZsSRqRYdsOA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1q9LsD-0060dJ-1v;
        Wed, 14 Jun 2023 10:29:01 +0200
Message-ID: <1038a5fd7d658cc29d11a6eb8776255c50e8226c.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: mac80211:  add eht_capa debugfs field.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     greearb@candelatech.com, linux-wireless@vger.kernel.org
Date:   Wed, 14 Jun 2023 10:29:00 +0200
In-Reply-To: <20230519162324.1633120-1-greearb@candelatech.com>
References: <20230519162324.1633120-1-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> +	/* TODO:  Fix and re-add this.  It compiles in 6.4 but not against 'nex=
t'
> +	 * according to the kernel build bot.
> +	 * PFLAG(PHY, 5, SUPP_EXTRA_EHT_LTF, "SUPP-EXTRA-EHT-LTF");
> +	 */
>=20

Well that's because the spec version was updated in wireless-next :)

So please adjust according to the new fields there.

johannes
