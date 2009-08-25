Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56967 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZHYIPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 04:15:10 -0400
MIME-Version: 1.0
In-Reply-To: <1251143422-13905-1-git-send-email-Mario_Limonciello@Dell.com>
References: <9b2b86520908220420p282c862fn9c44697db010a08d@mail.gmail.com>
	 <1251143422-13905-1-git-send-email-Mario_Limonciello@Dell.com>
Date: Tue, 25 Aug 2009 09:15:10 +0100
Message-ID: <9b2b86520908250115r2281fd66w8536f4e3817ea8b9@mail.gmail.com>
Subject: Re: [PATCH] compal-laptop: Replace sysfs support with rfkill support
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mario Limonciello <Mario_Limonciello@dell.com>
Cc: cezary.jackiewicz@gmail.com, linux-wireless@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/24/09, Mario Limonciello <Mario_Limonciello@dell.com> wrote:
> This drops the support for manually groking the files in sysfs
> to turn on and off the WLAN and BT for Compal laptops in favor
> of platform rfkill support.
>
> It has been combined into a single patch to not introduce regressions
> in the process of simply adding rfkill support

Ok, that looks better.

Thanks
Alan
