Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:33611 "EHLO
	mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbcBVTgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 14:36:38 -0500
MIME-Version: 1.0
In-Reply-To: <1456160420.16083.3.camel@redhat.com>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com> <1456160420.16083.3.camel@redhat.com>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Mon, 22 Feb 2016 14:35:57 -0500
Message-ID: <CA+A7VXU_8e9wVqr7AXu_2z9+68BTb-4jBBJBCgdgwiXRcYWkog@mail.gmail.com> (sfid-20160222_203700_101847_90BFD339)
Subject: Re: [PATCHv2 00/10] RFKill airplane-mode indicator
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 February 2016 at 12:00, Dan Williams <dcbw@redhat.com> wrote:
> On Mon, 2016-02-22 at 11:36 -0500, João Paulo Rechi Vita wrote:
>> This series implements an airplane-mode indicator LED trigger, which
>> can be
>> used by platform drivers. The default policy have have airplane-mode
>> set when
>> all the radios known by RFKill are OFF, and unset otherwise. This
>> policy can be
>> overwritten by one single userspace application at a time using the
>> operations
>> _AIRPLANE_MODE_INDICATOR_ACQUIRE and _AIRPLANE_MODE_INDICATOR_CHANGE.
>>
> Double-check your commit messages on some of these patches; they didn't
> get updated to add INDICATOR.
>

Thanks for catching this, Dan. I've sent an updated version fixing
this problem in reply to the patch where this slept through (9/10).

--
João Paulo Rechi Vita
http://about.me/jprvita
