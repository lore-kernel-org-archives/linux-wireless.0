Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:52721 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750998AbdHaV3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 17:29:04 -0400
Message-ID: <1504214940.2786.47.camel@perches.com> (sfid-20170831_232920_398299_BBB3D351)
Subject: Re: [PATCH] ath9k: remove cast to void pointer
From: Joe Perches <joe@perches.com>
To: Himanshu Jha <himanshujha199640@gmail.com>, kvalo@codeaurora.org
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 31 Aug 2017 14:29:00 -0700
In-Reply-To: <1504184863-9732-1-git-send-email-himanshujha199640@gmail.com>
References: <1504184863-9732-1-git-send-email-himanshujha199640@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-08-31 at 18:37 +0530, Himanshu Jha wrote:
> casting to void pointer from any pointer type and vice-versa is done
> implicitly and therefore casting is not needed in such a case.

You said you were going to remember to mention the tool
and script that did this.
