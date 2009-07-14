Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:55845 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZGNPmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 11:42:13 -0400
Received: by yxe14 with SMTP id 14so4316539yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2009 08:42:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0907091144h39a3df67wa9327157dedb172@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	 <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
	 <20090708114252.GG7199@hash.localnet>
	 <6c354a1a0907090942o66c4e1b8ue2c952cf7ed7bf9a@mail.gmail.com>
	 <b6c5339f0907090955v7b99a7ebq26e7cc67ab2493f5@mail.gmail.com>
	 <43e72e890907091002r2dd36efevbfbce06155beb7e5@mail.gmail.com>
	 <b6c5339f0907091048v665dcdf6i659e94de95038856@mail.gmail.com>
	 <43e72e890907091050p7bc08a25s86f9bb7a1c8740aa@mail.gmail.com>
	 <6c354a1a0907091136v5619efb5oc6a8a89ec24d4e74@mail.gmail.com>
	 <b6c5339f0907091144h39a3df67wa9327157dedb172@mail.gmail.com>
Date: Tue, 14 Jul 2009 11:34:26 -0400
Message-ID: <6c354a1a0907140834s6e71bcecp2b6dfe29ad0b187f@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Jasin Colegrove <j.wholesalesupply@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a quick update on this issue. I have come to the conclusion that
is indeed NOT a kernel driver issue. After removing the cruft and just
going the manual setup route for the complete bisect I was never once
able to repeat the behavior I had expirienced before. That was not
till i tried using wicd again. I have no reported this problem to the
appropriate bug tracker.

Sorry for wasting your precious time, I really do appreciate all your
responses and hard work!
