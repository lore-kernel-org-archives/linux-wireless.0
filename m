Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E01EC43217
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Oct 2022 16:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJNQ5R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Oct 2022 12:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJNQ5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2022 12:57:16 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69D2A2217;
        Fri, 14 Oct 2022 09:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=UHih30r86BOxLBr7EzwC+F2cF3xmXKqCZuE0BwywPj8=;
        t=1665766634; x=1666976234; b=bHqOGhsfyZ4L83Ra3EZxAEtNe9O+jHUohExV12TxXDPuAhX
        FQXb3Nztqiyi3og7s9UTdInC9d9JWHe8BCPBKKRu3D1TpTQTjlQK0MbyQajfE2V/gy55hb5PdmtiI
        8cV2woJ2ewbaca1eWeF39pKRXf5lqD01xJYl6C2zHp/PJ9JOwzdnQwuxj5y14mzfHZ7QQPBDwIq+x
        tbIBrCZBv4MRYe3l5rmUqkEBKCTEJXcxs/k8XKKVYhWwFB5L6pkL1mTx8ooxKKK4eOInjFJzDxk4s
        Cp5lkzp5MYQhJJi1rfNqmkWig077Wby1aEh9rK1EuMgt8IqenyS8cMDUDT6dCdAQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ojNzi-006hB5-1K;
        Fri, 14 Oct 2022 18:57:13 +0200
Message-ID: <05b245f76948c081ac5384f69d3b993ae24ac950.camel@sipsolutions.net>
Subject: Re: [RFC v5.10 0/3] mac80211 use-after-free fix
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>
Date:   Fri, 14 Oct 2022 18:56:44 +0200
In-Reply-To: <20221014163906.23156-1-johannes@sipsolutions.net>
References: <20221014163906.23156-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sorry about the duplicate, I'm on a train to Berlin and network was
spotty.

johannes
