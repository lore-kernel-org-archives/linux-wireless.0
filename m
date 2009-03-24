Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:62643 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZCXS7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 14:59:39 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3574250wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 11:59:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903241938.47155.chunkeey@web.de>
References: <200903241938.47155.chunkeey@web.de>
Date: Tue, 24 Mar 2009 14:59:37 -0400
Message-ID: <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com> (sfid-20090324_195944_546744_4A695B82)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: Bob Copeland <me@bobcopeland.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 2:38 PM, Christian Lamparter <chunkeey@web.de> wrote:
> Hi Luis,
>
> This is more or less what I need from ath9k's regulatory domain code.
> What's your opinion? Would you accept the changes, or do you see
> a potential conflict/problem with the design?

FWIW I had done a small bit of rework for sharing with ath5k, and
Luis has those patches now in somewhat better shape.  The last
patch set I made is here:

http://bobcopeland.com/kernel/wl/20090309/

-- 
Bob Copeland %% www.bobcopeland.com
