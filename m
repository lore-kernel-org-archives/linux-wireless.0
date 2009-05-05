Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:65072 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZEEDFw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 23:05:52 -0400
Received: by rv-out-0506.google.com with SMTP id f9so3247728rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 20:05:52 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 May 2009 20:05:37 -0700
Message-ID: <43e72e890905042005vb96f57aid70c476e38685dfe@mail.gmail.com>
Subject: oops during stress test - today's wl
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mcgrof@pogo ~/wireless-testing (git::master)$ git-describe
v2.6.30-rc4-22720-gb2382a4

While running iperf, after about 1 hour.

http://bombadil.infradead.org/~mcgrof/oops-img/09-05/oops-01-v2.6.30-rc4-22720-gb2382a4.jpg

Image probably doesn't help much.. but its what I got.. I'd look more
but its getting late here, so I'm out. I'll use netconsole tomorrow.

  Luis
