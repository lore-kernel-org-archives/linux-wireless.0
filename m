Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21142 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbaKKNFs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 08:05:48 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: James Cameron <quozl@laptop.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 11 Nov 2014 05:05:43 -0800
Subject: RE: [PATCH] mwifiex: simplify ad hoc join capability info
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951821CF27E7@SC-VEXCH1.marvell.com> (sfid-20141111_140551_956024_2737B454)
References: <20141111052127.GA18499@us.netrek.org>
In-Reply-To: <20141111052127.GA18499@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

>While preparing an ad-hoc start command, the capability info bitmap is
>needlessly set from the command, and then the ESS bit cleared.
>
>Change to set the bitmap directly without reference to the command.
>
>Signed-off-by: James Cameron <quozl@laptop.org>

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks,
Amitkumar
