Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47597 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3HGG7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 02:59:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: setup peer UAPSD flag correctly
References: <1375853036-2418-1-git-send-email-janusz.dziedzic@tieto.com>
Date: Wed, 7 Aug 2013 09:59:28 +0300
In-Reply-To: <1375853036-2418-1-git-send-email-janusz.dziedzic@tieto.com>
	(Janusz Dziedzic's message of "Wed, 7 Aug 2013 07:23:56 +0200")
Message-ID: <87li4e6l67.fsf@kamboji.qca.qualcomm.com> (sfid-20130807_085941_298206_19FEBCA8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> Setup UAPSD peer rate control (FW flag)
> correctly.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This doesn't answer the question "Why?". I have now added a section in
the wiki about what the commit log should contain. Hopefully that helps.

Submitting patches

Send patches to the mailing lists below. Kalle Valo reviews the patches
within the next few days and, if they are ok, commits them to ath.git.

To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org

Preferably use ath.git master as the baseline for patches. Other trees
can be used as well, but then the chances of conflicts are higher.

Guidelines for patches:

* MUST be compiler warning free.

* MUST be sparse warning free.

* Commit log MUST not be empty.

* The commit log MUST answer the question "Why?":

  * Describe the motivation behind the bug.

  * How does it change the functionality from user's point of view?

  * Does it fix a bug? If it does, please describe the bug (doesn't need
    to be long). Also if there's a public bug report add a link to the
    bug report.

* If others have reported the issue commit log SHOULD use Reported-by:
  and Tested-by: tags.

* SHOULD be checkpatch clean:

  * FIXME: add checkpatch example with correct arguments

* Patches SHOULD be sent with git send-email tool.

* Patchsets SHOULD contain no more than 12 patches.

The terminology is from http://www.ietf.org/rfc/rfc2119.txt

http://wireless.kernel.org/en/users/Drivers/ath10k#Submitting_patches

Please comment.

-- 
Kalle Valo
