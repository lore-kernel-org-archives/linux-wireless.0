Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.230]:20911 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131AbYBUU4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 15:56:53 -0500
Received: by wr-out-0506.google.com with SMTP id c48so272900wra.23
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 12:56:51 -0800 (PST)
Message-ID: <84ac67910802211256l66573e79o3abdc256b2d8eaec@mail.gmail.com> (sfid-20080221_205719_492855_EEEA8DD2)
Date: Thu, 21 Feb 2008 20:56:50 +0000
From: "Ahmed Ammar" <b33fc0d3@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: b43 (H/W 4306 Rev. 03)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080221201811.GM3094@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <84ac67910802210444q4da4f02bo2d172493ef2c7158@mail.gmail.com>
	 <20080221163134.GF3094@tuxdriver.com>
	 <84ac67910802211007n55569d6j92dee1da198e9b1d@mail.gmail.com>
	 <20080221182615.GK3094@tuxdriver.com>
	 <84ac67910802211204y575e893cnd056bbd7442f27ea@mail.gmail.com>
	 <20080221201811.GM3094@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  > bonding: bond0: enslaving wlan0 as an active interface with a down link.
>
>
> This looks a little odd.  Have you had this working in the past?
>  Can you try a setup using just wlan0 (i.e. without bonding)?
>

I have tried with and without bonding, and bonding is definitely not
the issue here, I am pretty sure this is something wrong with the
driver/firmware.

I am willing to test any patches that will give you better debugging,
or even direct access to my box?
