Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:14277 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbYJHVYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 17:24:15 -0400
Received: by mu-out-0910.google.com with SMTP id g7so3387316muf.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2008 14:24:13 -0700 (PDT)
Message-ID: <45e8e6c40810081424t7b53987yac26da9a54d8c6c6@mail.gmail.com> (sfid-20081008_232418_587098_843CCD5B)
Date: Wed, 8 Oct 2008 14:24:13 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Subject: trouble scanning with iwlagn and '4965 HW
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm having trouble scanning with my '4965 cards and current
wireless-testing unless I disable HW scan (ie: load with
disable_hw_scan=1 option).  Without disabling HW scan, I see a few APs
and then, if I repeat the scan a few times, I usually see fewer
results.  Either way, eventually there are no results until I reload
the module.  With HW scan disabled, I consistently see more results
(ex: 42 APs instead of 13) and I don't get into the "no scan results"
state (the results are consistent with repeated scans).

Is anyone else having this issue?  Thanks,

  -Andrey
