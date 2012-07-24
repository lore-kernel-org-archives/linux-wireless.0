Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56258 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab2GXDkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 23:40:36 -0400
Received: by obbuo13 with SMTP id uo13so10493888obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 20:40:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVNnqTBi10vGsjYqYBOedtaThjyJuRt6o=XpZF_dRaqQsA@mail.gmail.com>
References: <1343092554-17734-1-git-send-email-yeohchunyeow@gmail.com>
	<CAG6hwVNnqTBi10vGsjYqYBOedtaThjyJuRt6o=XpZF_dRaqQsA@mail.gmail.com>
Date: Tue, 24 Jul 2012 11:40:35 +0800
Message-ID: <CAEFj986CjnbT=j_a7wHvMX9WshjtGD1wttad5iAPM_ViaQhqTg@mail.gmail.com> (sfid-20120724_054038_969597_BD1EC042)
Subject: Re: [PATCH v3] mac80211: add extra checking for RC init upon
 receiving mesh beacon
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Thomas

>>         sta->last_rx = jiffies;
>
> You should avoid duplicating this assignment.

I think that we should also update the sta->last_rx if the
sta->plink_state is not NL80211_PLINK_ESTAB, am I right?

Please advice. Thanks

Regards,
Chun-Yeow
