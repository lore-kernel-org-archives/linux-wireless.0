Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93F3C001DB
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Aug 2023 18:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjHHSpC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Aug 2023 14:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjHHSoZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2023 14:44:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D1A3D1A7;
        Tue,  8 Aug 2023 09:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=8W7ui4/ArngIuKAXYPl2b6CpuAAumlmrDpsvogYUsJU=;
        t=1691512888; x=1692722488; b=VqHkCl1ozxULWVA3NeNtibulfF/v8/0ZJ4d8FbBCzmZrndj
        QuU6ZxSQNzyaNHCKkC+9bqzTppTjUs/gA/DTwFH3Chyelyx0Mup2YtSq0NoCJpy247wVeDtbV6YiF
        8pBcVUOHDa3dHVhrxwehEzNJT3/ZeJTSShsvRetlkwDP+t/UTyU/ZO/TeG/psnCwm1DGqrL3BwAJK
        beH/W7GdiIa7r3Tk80xl/aKU1ffWrTF6DlOo+r2u8J4rloxkuUPRP7D+nvjhlnfYMmZYGlmyO2kdx
        Z/KkXLstdRkVZ2L5ncH/6j6kp5Df3wGaa8eehvR8ZR6lxZabqZGBikzlkpxdfOcg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qTI0x-00CQmg-1I;
        Tue, 08 Aug 2023 10:24:27 +0200
Message-ID: <cdf75cdfeb3640e7096940b3f15a8cd86bf5451e.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: mesh: Remove unused function declaration
 mesh_ids_set_default()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yue Haibing <yuehaibing@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nbd@nbd.name, pagadala.yesu.anjaneyulu@intel.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Aug 2023 10:24:26 +0200
In-Reply-To: <20230731140712.1204-1-yuehaibing@huawei.com>
References: <20230731140712.1204-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2023-07-31 at 22:07 +0800, Yue Haibing wrote:
> Commit ccf80ddfe492 ("mac80211: mesh function and data structures definit=
ions")
> introducted this but never implemented.
>=20

Btw, are you detecting these with some kind of tool? Having the tool
would probably be more useful than you sending all these patches all the
time ...

johannes
