Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59737 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2LEW2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 17:28:19 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so2271708wey.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 14:28:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOpc7mF5yW=UtzYDASkbHbNo4QHOmKuWjNK+eqF36OZjY6SUFg@mail.gmail.com>
References: <1354393301-11051-1-git-send-email-lewurm@gmail.com>
 <CAAr_hs53SddPbUUAdaqBFjc8fx-sqDPVjqkq645cMptQqsaQOw@mail.gmail.com>
 <CAD2nsn1WUzo0jBv=zJ4Bw+A_4=zr9YszCzP+X4ujXFfGwKAk8w@mail.gmail.com> <CAOpc7mF5yW=UtzYDASkbHbNo4QHOmKuWjNK+eqF36OZjY6SUFg@mail.gmail.com>
From: Bernhard Urban <lewurm@gmail.com>
Date: Wed, 5 Dec 2012 23:27:38 +0100
Message-ID: <CAAr_hs7AwmSKFhf3y-2nqXAR=GQGyen_trAh8ppJkb5i-mrckA@mail.gmail.com> (sfid-20121205_232823_026034_7AF3215C)
Subject: Re: [ath9k-devel] [PATCH] ath9k_htc: update RSSI values only when the
 device is associated
To: Holger Schurig <holgerschurig@gmail.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>, m.sujith@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, c_manoha@qca.qualcomm.com,
	markus@indoo.rs, Sujith.Manoharan@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 4, 2012 at 6:02 PM, Holger Schurig <holgerschurig@gmail.com> wrote:
> And I think the commercial for your sponsor should be after the "---"
> line, not inside the commit description ...

well, try `git log | grep -i sponsor' in the git tree. I don't find
something in the docs though.
