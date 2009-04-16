Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:32034 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZDPRHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 13:07:18 -0400
Received: by rv-out-0506.google.com with SMTP id f9so494412rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 10:07:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1239727902-11866-1-git-send-email-hauke@hauke-m.de>
References: <1239727902-11866-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 16 Apr 2009 10:07:02 -0700
Message-ID: <43e72e890904161007h43d131e5uc98018037e84d544@mail.gmail.com> (sfid-20090416_190723_870861_69A04CF8)
Subject: Re: [PATCH] [compat-2.6] Reflect changes in wireless-testing.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 14, 2009 at 9:51 AM, Hauke Mehrtens <hauke@hauke-m.de> wrot=
e:
> * Change the location of ath5k, ath9k and ar9170.
> * modify some scripts to work with recent version of wireless-testing=
=2E
> =C2=A0* ath9k will be loaded if madwifi is deactivated.
> =C2=A0* Broadcoms wl.ko will be deactivated if b43 or b43legacy are l=
oaded.
> =C2=A0* Many modules were added or chanced their name in the last mon=
ths.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Applied and new tarball generated, thanks!

Updated from /home/wireless/wireless-testing, git-describe says:
v2.6.30-rc2-21665-gca0be26
wireless-testing latest tag:
master-2009-04-15
This is compat-release:
master-2009-04-15

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
