Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:44460 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYCGSCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 13:02:39 -0500
Date: Fri, 7 Mar 2008 13:02:36 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, Jiri Slaby <jirislaby@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/8] ath5k: latest revised patches
Message-ID: <20080307180236.GS28995@ruslug.rutgers.edu> (sfid-20080307_180245_202665_1FF94C9C)
References: <43e72e890802281456j22236cdegb4cf0c90d954af05@mail.gmail.com> <43e72e890803061907j2dca57f1k6907e2942f8a70fc@mail.gmail.com> <40f31dec0803070432i2e313b32q68493f0af4a0105c@mail.gmail.com> <43e72e890803070915l35564f7ao1c25752b03a9531d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890803070915l35564f7ao1c25752b03a9531d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


OK -- so just to re-cap, patches 1-6 remain the same, patch 7 was
changed to not have the helper but still respect 80-char limit, 
and patch 8 modified to apply ontop of new patch 7.

Now series can be wget'd from:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath5k/2008-03-07/

  Luis
