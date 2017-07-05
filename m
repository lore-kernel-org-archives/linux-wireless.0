Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32785 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdGENie (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 09:38:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Switching away from ath10k patchwork project
Date: Wed, 5 Jul 2017 13:29:20 +0000
Message-ID: <87tw2rgggu.fsf@kamboji.qca.qualcomm.com> (sfid-20170705_153905_146955_1E41AB5C)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TL;DR:

Starting from patches submitted today I'm switching away from
ath10k specific patchwork project to the general linux-wireless
patchwork project.

The longer story:

For legacy reasons we have had two patchwork projects, the main project
being linux-wireless (which tracks linux-wireless mailing list):

https://patchwork.kernel.org/project/linux-wireless/list/?state=3D*

And then we have a separate project for ath10k (which tracks the ath10k
mailing list):

https://patchwork.kernel.org/project/ath10k/list/?state=3D*

This creates a confusion as people don't always know which patchwork
project to follow. To simplify this I'm dropping the ath10k project in
patchwork and track also ath10k patches using the general linux-wireless
project so that all wireless patches can be tracked from the same
patchwork project.

The only downside from this is that if someone posts a patch only to the
ath10k list and forgets to CC linux-wireless I will not see it as I only
take patches from patchwork. But we have instructed everyone to CC
linux-wireless anyway[1] so hopefully this is a small problem. I do
remember having few cases where the patch was not CCed to
linux-wireless, but usually it's actually the other way around (people
forget to CC the ath10k list). So I'm not expecting that much problems
with this change.

[1] https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatc=
hes

--=20
Kalle Valo=
