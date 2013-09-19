Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35044 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3ISOY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 10:24:58 -0400
Received: by mail-ob0-f169.google.com with SMTP id wp4so10090560obc.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Sep 2013 07:24:58 -0700 (PDT)
Message-ID: <523B0937.6030109@lwfinger.net> (sfid-20130919_162504_128788_F1BDB890)
Date: Thu, 19 Sep 2013 09:24:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Timothy Rundle <tgrundlesr@gmail.com>
CC: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk> <522E896E.7000607@lwfinger.net> <522EB51A.2080004@ilande.co.uk> <522F3757.8030600@lwfinger.net> <522F7B61.6060208@ilande.co.uk> <5230CDF1.1040905@lwfinger.net> <CALa3VXbxQ1Z2J5weV7rQ16c53D1MQyDL1YGQrV6EkCJYfh=uYA@mail.gmail.com> <523350DC.5050905@lwfinger.net> <CALa3VXZ2+7v-0xrWgoPsAjaaybfMUDONZae8bSx4XhAc6h7wUw@mail.gmail.com> <523A9E4A.5060309@ilande.co.uk> <CALa3VXZ0B=CcbJDX5epB7Me9tLcsuiTqjpoSX2RW6dWsPxKxEQ@mail.gmail.com>
In-Reply-To: <CALa3VXZ0B=CcbJDX5epB7Me9tLcsuiTqjpoSX2RW6dWsPxKxEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2013 05:45 AM, Timothy Rundle wrote:
> @Larry,
>
> The patch/firmware seemed to help a little with the range (increased
> from 12 to about 20), but I still can't connect to the mail router
> about 30 feet away.
>
> @Mike,
>
> Yes my routers are 802.11b/g only.  Been meaning to upgrade, but
> things have been working well so I have been putting off.
>
> Timothy
>
> On Thu, Sep 19, 2013 at 2:48 AM, Mark Cave-Ayland
> <mark.cave-ayland@ilande.co.uk> wrote:
>> On 19/09/13 01:42, Timothy Rundle wrote:
>>
>>> I found that if I setup a old wireless router as a repeater and keep
>>> it within 10-12 feet I have a stable connection.  If I move it back to
>>> 12-15 the connection becomes less reliable.  Anything past 15 feet is
>>> unusable.
>>>
>>> I see there have been lots of conversations on the topic and you are
>>> working on some power management changes.  If you need me to do any
>>> testing let me know.
>>
>>
>> Hi Timothy,
>>
>> Thanks for the information. It's just a hunch at the moment, but is your
>> wireless router 802.11b/g only, i.e. it either doesn't have 802.11n enabled
>> or doesn't support 802.11n at all?

My device connects equally well with 802.11n and 802.11b/g routers.

Mark: 802.11b is restricted to the CCK rates, which are 1, 2, 5.5, and 11 Mbps. 
In 802.11g, rates 6, 12, 18, 24, 36, and 54 Mbps are all OFDM encoded.

Larry


