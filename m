Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60173 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965064AbcAUO6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 09:58:49 -0500
Received: from potku.adurom.net (a88-115-185-251.elisa-laajakaista.fi [88.115.185.251])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: kvalo@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 6EE5B6037C
	for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 14:58:48 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: wireless-drivers: random cleanup patches piling up
Date: Thu, 21 Jan 2016 16:58:44 +0200
Message-ID: <87wpr3x9ln.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_155854_644978_1153FC7B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have quite a lot of random cleanup patches from new developers waiting
in my queue:

https://patchwork.kernel.org/project/linux-wireless/list/?state=10&delegate=25621&order=date

(Not all of them are cleanup patches, there are also few patches
deferred due to other reasons, but you get the idea.)

These cleanup patches usually take quite a lot of my time and I'm
starting to doubt the benefit, compared to the time needed to dig
through them and figuring out what to apply. And this is of course time
away from other patches, so it's slowing down "real" development.

I really don't know what to do. Part of me is saying that I just should
drop them unless it's reviewed by a more experienced developer but on
the other hand this is a good way get new developers onboard.

What others think? Are these kind of patches useful?

-- 
Kalle Valo
