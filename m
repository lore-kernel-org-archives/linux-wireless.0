Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35330 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2KMXXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 18:23:49 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4314105eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 15:23:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352836486.9466.25.camel@jlt4.sipsolutions.net>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1352809427-29682-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352836486.9466.25.camel@jlt4.sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 14 Nov 2012 10:23:28 +1100
Message-ID: <CAGRGNgXsGh1qLo8gq+L5Uedu=F=Eob_9j4x6jxrEg_=wPnOfWA@mail.gmail.com> (sfid-20121114_002353_089220_B7A5B013)
Subject: Re: [PATCH v7 2/2] wireless: integrate wil6210 driver into build structure
To: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vladimir,

On Wed, Nov 14, 2012 at 6:54 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-11-13 at 14:23 +0200, Vladimir Kondratiev wrote:
>
>> +config ATH_COMMON
>> +     tristate
>
> I think you should (in the changelog) explain this change and why you
> touch all drivers.

It might be even better to split it out into a separate patch.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
