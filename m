Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:56633 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaDDKZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 06:25:55 -0400
Message-ID: <533E88B1.4050408@broadcom.com> (sfid-20140404_122558_993659_DA79FAF8)
Date: Fri, 4 Apr 2014 12:25:53 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Fariya <fariyaf@gmail.com>
CC: <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Fwd: Submission of firmware for driver RSI
References: <CAG+h2qjs9WanwFjE7=kAhV2Z4ObaQ7pGqH_+5w-pqz9JED_u=A@mail.gmail.com> <CAG+h2qimn764Zea9FSL39Th2PrhBsxExvqjawu4UwkTcS+0gRQ@mail.gmail.com>
In-Reply-To: <CAG+h2qimn764Zea9FSL39Th2PrhBsxExvqjawu4UwkTcS+0gRQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/04/14 09:20, Fariya wrote:
> Hi,
>
> I would like to submit the RSI firmware to the linux-firmware git. Can
> anyone point me to the procedure for f/w submission? Can I submit the
> f/w onto this mailing list?
>

The patch can be submitted to this mailing list (in Cc: field) and you 
should send it to Ben Hutching as a binary patch, ie. use -B option with 
'git format-patch'. You also would need to update the WHENCE file and 
probably add a license file.

Regards,
Arend
