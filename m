Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63954 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3IJJSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 05:18:02 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so413959wid.9
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 02:18:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <522E5558.4070008@candelatech.com>
References: <522E1D31.2090403@candelatech.com> <CABPxzYLaLUdCXULmx7mV5Gk7L_RrnG4Zq-vO6XRCUt0pvm9SJA@mail.gmail.com>
 <522E5558.4070008@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 10 Sep 2013 14:47:41 +0530
Message-ID: <CABPxzYKcVyomdXaDxT3mLXQb0sYfM=UdoZwpbsb4qohTkPU3Cw@mail.gmail.com> (sfid-20130910_111806_592962_1E5C9A06)
Subject: Re: Always send management frames at MCS-0??
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 4:40 AM, Ben Greear <greearb@candelatech.com> wrote:

> Would forcing them to a lower rate at least theoretically improve
> the chance that the packets are properly delivered?
Yes. But we already have a RC algorithm taking care of that.
Right?
