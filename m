Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740E0C3F2D1
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 13:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C97020637
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 13:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCEN7e convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 08:59:34 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:54794 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgCEN7e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 08:59:34 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 51213CECEB;
        Thu,  5 Mar 2020 15:09:00 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] mac80211_hwsim: add frame transmission support over
 virtio
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200305143212.c6e4c87d225b.I7ce60bf143e863dcdf0fb8040aab7168ba549b99@changeid>
Date:   Thu, 5 Mar 2020 14:59:32 +0100
Cc:     linux-wireless@vger.kernel.org, Erel Geron <erelx.geron@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2F7ADB4C-8C2C-4DEC-80AF-9E2D6B55CA88@holtmann.org>
References: <20200305143212.c6e4c87d225b.I7ce60bf143e863dcdf0fb8040aab7168ba549b99@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

> This allows communication with external entities.
> 
> It also required fixing up the netlink policy, since NLA_UNSPEC
> attributes are no longer accepted.
> 
> Signed-off-by: Erel Geron <erelx.geron@intel.com>
> [port to backports, inline the ID, use 29 as the ID as requested,
> drop != NULL checks, reduce ifdefs]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

since the module now can auto-load, don’t you want to change radios = 2 to radio = 0?

Regards

Marcel

