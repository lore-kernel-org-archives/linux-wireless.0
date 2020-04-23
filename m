Return-Path: <SRS0=d7P/=6H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A7FC54FCB
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 14:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D2212087E
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Apr 2020 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587653263;
	bh=SxyGQHkd0kcs2U6kVroogS8EX8n6xP/5/eW4cnGhP2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=mKseFxmFIMq2IldCPcJJM0ZIJaZUMV0KKh4zv9mi82Vmg5S21uA7SRq0cHlmMEPLY
	 DsiqtvRzLoSI9dB8JoMBd/s62ubCB4cakhQGKyZKxqoZXFB4RPgPZw2PUxeqhocmRQ
	 UwNkl+yoJmVJFER8zv34lM4QW2jm4J+IvFl3E/pA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgDWOrj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 Apr 2020 10:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgDWOrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Apr 2020 10:47:39 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A889A2074F;
        Thu, 23 Apr 2020 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587653259;
        bh=SxyGQHkd0kcs2U6kVroogS8EX8n6xP/5/eW4cnGhP2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qDHQTLKs8uQ7KZmmrcux3fu6B5vJDbaGT8DjmnQGpm+YFoAh5shJbv3JFnMjFH7vZ
         am609VgcZcLFXG/4VN81vf3THcxDqTGRVqNtOa3OVXjE0aiCcKG5gjV2hMxNCkakln
         lg7JdGzThZ2fAtrhff4gIN4lhHEpl/CLVqNh41m8=
Date:   Thu, 23 Apr 2020 15:47:36 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>, yhchuang@realtek.com,
        Dejin Zheng <zhengdejin5@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] iopoll: Introduce read_poll_timeout_atomic macro
Message-ID: <20200423144736.GN4808@sirena.org.uk>
References: <20200423063811.2636-1-kai.heng.feng@canonical.com>
 <87lfmmn1fo.fsf@kamboji.qca.qualcomm.com>
 <20200423102347.GC4808@sirena.org.uk>
 <87eeseigs9.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="citGix+cyBYE+lqp"
Content-Disposition: inline
In-Reply-To: <87eeseigs9.fsf@kamboji.qca.qualcomm.com>
X-Cookie: This unit... must... survive.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--citGix+cyBYE+lqp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 23, 2020 at 02:27:02PM +0300, Kalle Valo wrote:

> Oh, ok. As patch 2 goes to my wireless-drivers-next tree would it be ok
> for everyone if I take this patch as well?

I'd give it a bit longer than usual for people to review but yeah, if
nobody complains it's probably reasonable.

--citGix+cyBYE+lqp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6hqocACgkQJNaLcl1U
h9CL+Af+KRWt3kOxuDKEMWFarbD/Rlly0YZ1l5BYoRj/9CQKNWCcG0Ptb8+H558O
IbGgrmKk9SM5zLI/qYCEEizRMtVyA+KCwxiSaPAYYfyTQCThvh7g0EUQZED5DS27
mmF4FnO24mLHaVBgDGswVNRtl6xFEzYBlO1S5Vg/E9hn/JRoNCWY/jse2FQxc8OD
MLCjMWbUJXgtpbF2v5iaufqT/4TZJPWa2DPAS39/yEjC64usdPPk9efUjc3+9ivS
trWJlYc/roepMOdpQEFvwlOduJSBbuS2SKAowIKXCnjm+2DAiiGRKLcz1FF625b1
D7QmC+Nm2S6YPouyjL4iFA8P0C48Aw==
=KBox
-----END PGP SIGNATURE-----

--citGix+cyBYE+lqp--
