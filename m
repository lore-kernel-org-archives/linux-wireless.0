Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57770 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2HFToz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:44:55 -0400
Received: by obbuo13 with SMTP id uo13so6327782obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Aug 2012 12:44:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20511.62502.380685.674021@gargle.gargle.HOWL>
References: <20511.62502.380685.674021@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 6 Aug 2012 12:44:35 -0700
Message-ID: <CAB=NE6Wz0FEcZd3qvDET=kst3gRK+wu=k3yuMt_D1mfkT3+k5Q@mail.gmail.com> (sfid-20120806_214459_688264_41CC95AA)
Subject: Re: [PATCH 3.5.y 2/2] compat-wireless: Add new cherry-picked patches
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 9:43 AM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

8 of the hunks were just version of git ouputs at the end of the patch
files, we gotta find a way to ignore that from git format-patch. I
didn't find anything yet.

Thanks so much for these patches! I've applied them and pushed them,
I'll run a series of tests later and appropriately tag things after
the test, and push new respective releases then.

  Luis
