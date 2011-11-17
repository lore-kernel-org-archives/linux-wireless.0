Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33795 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1KQHgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 02:36:50 -0500
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Greg Dietsche <gregory.dietsche@cuw.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: pull request: iwlegacy 2011-11-16
References: <20111116122205.GA4409@redhat.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 17 Nov 2011 09:36:44 +0200
In-Reply-To: <20111116122205.GA4409@redhat.com> (Stanislaw Gruszka's message of "Wed\, 16 Nov 2011 13\:22\:06 +0100")
Message-ID: <87y5vf8ak3.fsf@purkki.adurom.net> (sfid-20111117_083654_821709_316A4CB5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> Please pull iwlegacy cleanup changes done by Greg and me, intended
> for 3.3. These request include huge patches with file renaming and
> automatic code processing done by sed and indent. Driver is still
> quite messy and need more cleanup, but these massive changes bring
> driver close to the state that we could name it maintainable.
>
> Hopefully with having clean, maintainable code I will be able to fix
> some nasty not easy reproducible bugs, we still have in the iwlegacy
> driver.

I haven't seen these patches on linux-wireless mailing list at all.
Isn't it recommended that all wireless patches are sent to
linux-wireless for public review?

-- 
Kalle Valo
