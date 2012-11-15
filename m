Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33137 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286Ab2KOPzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 10:55:24 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so1408951lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2012 07:55:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352978222-13866-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1352978222-13866-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1352978222-13866-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Thu, 15 Nov 2012 17:55:23 +0200
Message-ID: <CAMXE1-oypT8XMZBxBwKP5v9+xW4QS579PtmhCgPhxhodHoVETw@mail.gmail.com> (sfid-20121115_165528_691338_24FC5966)
Subject: Re: [PATCH v8 4/4] dynamic_debug: dynamic hex dump
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vladimir,

On Thu, Nov 15, 2012 at 1:17 PM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> Introduce print_hex_dump_debug() that can be dynamically controlled, similar to
> pr_debug.

You could just use "%*ph" specifier in pr_debug

Regards,
Andrei
