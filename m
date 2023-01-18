Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F72C32793
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Jan 2023 15:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjARPoy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Jan 2023 10:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjARPox (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2023 10:44:53 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B70B173B
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2023 07:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=LJC/xXpHhVOiedjRtJQtrGcj09WKKYiUUAngKhtdJdU=;
        t=1674056692; x=1675266292; b=CV9kixcF70s8/Dc/n8/qn82UIC5Vo9kQI0SwyzJR57gWBst
        7xdS17i7T/laSe3MfzrWZpwBIekqZ/WvX6wGc75TPFcP4cKYGo99kaB39UsL63S9+t/J+fIxyryia
        wk9sl0AdPZhSB8vqscONn+jlcn7mMOM1e64ozJ/gOWqgbsXTRB8/Z+33CIX58UvcXf/zCXF5VSlQO
        uI2kv0ObrXB9iQuPJ2p+Scw6HL3XdBxUQ+JGOynXJ5oSrYIEpe+KPkyisH39FOGpkHn3ngq0cdHu6
        RDdJTV8ET+8zpYj3gc1j2GIU1GnX5o1JT4gw/K9pIkjmUiY0eSMVNmraqUVJ0Hug==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pIAcL-005ePz-31;
        Wed, 18 Jan 2023 16:44:50 +0100
Message-ID: <07a3bb730d01f9d9423dc2065f62fb93b9671a80.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] wifi: cfg80211: Use MLD address to indicate MLD STA
 disconnection
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Veerendranath Jakkam <quic_vjakkam@quicinc.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 18 Jan 2023 16:44:49 +0100
In-Reply-To: <20221206080226.1702646-4-quic_vjakkam@quicinc.com>
References: <20221206080226.1702646-1-quic_vjakkam@quicinc.com>
         <20221206080226.1702646-4-quic_vjakkam@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2022-12-06 at 13:32 +0530, Veerendranath Jakkam wrote:
> Use station's MLD address to report disconnection of MLD station.
> Updated documentation in multiple places to indicate the same.
>=20

Applied, but in the future please write commit messages in=C2=A0imperative:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#commit_messages

johannes
