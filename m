Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:38104 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab0KVSAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 13:00:21 -0500
Message-ID: <4CEAAFB1.1020707@create-net.org>
Date: Mon, 22 Nov 2010 19:00:17 +0100
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Use case for the radiotap rate patch
References: <4CE8F8D9.1020201@create-net.org> <1290440383.5718.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1290440383.5718.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il 22/11/2010 16:39, Johannes Berg ha scritto:
> radiotap now has a way to specify one attribute multiple times, so that
> should be used for MRR
Is there a patch available for the linux kernel that supports this
new approach to specify the MRR? I can easly modify the click
radiotap header generation code, but without the support in
the kernel it would be rather pointless.

R.
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

