Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:64297 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYJWDKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 23:10:44 -0400
Received: by el-out-1112.google.com with SMTP id z25so36840ele.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 20:10:43 -0700 (PDT)
Message-ID: <43e72e890810222010w215b278bya788e0c94250b517@mail.gmail.com> (sfid-20081023_051049_214685_98172411)
Date: Wed, 22 Oct 2008 20:10:42 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3] mac80211: Re-enable aggregation
Cc: linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	Jouni.Malinen@atheros.com, johannes@sipsolutions.net,
	tomasw@gmail.com, Sujith <Sujith.Manoharan@atheros.com>
In-Reply-To: <18685.37489.577735.596008@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18685.37489.577735.596008@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 1:27 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Wireless HW without any dedicated queues for aggregation
> do not need the ampdu_queues mechanism present right now
> in mac80211. Since mac80211 is still incomplete wrt TX MQ
> changes, do not allow aggregation sessions for drivers that
> set ampdu_queues.
>
> This is only an interim hack until Intel fixes the requeue issue.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> Signed-off-by: Luis Rodriguez <Luis.Rodriguez@Atheros.com>

Poke.

  Luis
