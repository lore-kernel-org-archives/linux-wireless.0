Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47851 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0KDC45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 22:56:57 -0400
Received: by vws13 with SMTP id 13so1276844vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 19:56:57 -0700 (PDT)
Message-ID: <4CD22112.4080103@lwfinger.net>
Date: Wed, 03 Nov 2010 21:57:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rogerio Luz Coelho <rogluz.news@gmail.com>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/9] rtl8187: fix wrong register initialization in 8187B
References: <309278.75116.qm@web29520.mail.ird.yahoo.com>	<4CCF7B73.7040906@lwfinger.net>	<4CCF7EFC.1050000@mandriva.com.br>	<AANLkTinEsp+-EU4Oau71qHbL6ftO544+H4GA3WZk7CX5@mail.gmail.com>	<20101103112843.15e51de7@gotham.conectiva> <AANLkTikkXd1w-6Cfq3T4gAKSar7YPV8DOwqEbvSPe7c3@mail.gmail.com>
In-Reply-To: <AANLkTikkXd1w-6Cfq3T4gAKSar7YPV8DOwqEbvSPe7c3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2010 09:41 PM, Rogerio Luz Coelho wrote:
> Could I apply these patches on top of Cascardo's?
> 
> Or should I tru individually for better testing ?

Herton said to apply after Cascardo's changes. I tested them individually to
test whether the system would build at each step of the way. Only the last two
made any difference in the throughput. You can just test before, and after all
of them are applied.

Larry

