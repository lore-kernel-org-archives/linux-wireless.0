Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1ADC38145
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Sep 2022 14:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbiIBOvP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiIBOvB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2022 10:51:01 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A956B8EE
        for <linux-wireless@vger.kernel.org>; Fri,  2 Sep 2022 07:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=7neXwG8yzy1mjPinJYwDCDvTr95cXbTf8dkwsBM+MBI=; t=1662127984; x=1663337584; 
        b=see5mLyAus1FylwmLsZs22thlSuD4ezTYfeWMUG54cD7imDGoa1BW4ITUwnSX5Y6ufMdwUBpeDD
        bdtJsFRPqFP4th2ODP3BhE4GcyCCEWzvXnwWQsDLzWxlPANqjUiCLnUQp52lGckKcZQLo0Ch7DF+f
        yJ0cCZz0WHRzMuDaaYZaHQWu9GPfuYi914YwB5kIap/GM6LPH+B7d2mM0wvibSY+nO8A0YLEcXYR9
        sYeCQZy+oU0Efjw4b7sK5eqePZqkQQoxbNqd+1//YIbGoy0MjdP1KZk0SspqUbfrVivmIv0e7pewc
        VetK5q5v7Qy8Ge3I5LhPQR6bTr62SjIK6GFg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oU7Pq-006Ch3-2C
        for linux-wireless@vger.kernel.org;
        Fri, 02 Sep 2022 16:13:02 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 00/27] another set of MLO patches
Date:   Fri,  2 Sep 2022 16:12:32 +0200
Message-Id: <20220902141259.377789-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Alright, here's another set of MLO patches :-)

I'm preparing everything here for link switching (which is also in
wireless-next/mld-wip branch already), along with some fixes to
avoid VLANs/4-addr and various other fixes that came up during
this work. Not all of them are related, e.g. the SW scan stop just
came up due to the new hwsim checks.

johannes


