Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:40763 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbZFVPr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 11:47:57 -0400
Received: by an-out-0708.google.com with SMTP id d40so6665344and.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 08:47:59 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Jun 2009 08:47:39 -0700
Message-ID: <43e72e890906220847u4faaeb2paa15365360c3c080@mail.gmail.com>
Subject: Pending ath9k bugs June, 2009
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@lists.ath9k.org, parag.warudkar@gmail.com,
	rootkit85@yahoo.it, gaurav.jauhar@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We're down to 2 kernel.org bug reports for ath9k:

http://bugzilla.kernel.org/show_bug.cgi?id=13581
"ath9k doesn't work with newer kernels"
This is a regression between 2.6.29 and 2.6.30, someone needs to look at this.

http://bugzilla.kernel.org/show_bug.cgi?id=13141
"AR5008/DWA-552 - Very slow"
Patches have been supplied, needs user feedback.

If you are aware of any other issues please do report.

  Luis
