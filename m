Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cock.li ([185.100.85.212]:50180 "EHLO cock.li"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756421AbcIURpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Sep 2016 13:45:38 -0400
Subject: Re: RTL8192EU on rtl8xxxu driver breaks every few minutes
References: <c6784dde-65df-87cd-f97e-33fbd8dd55ff@waifu.club>
 <wrfj4m5acouw.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org
From: "Franc[e]sco" <lolisamurai@waifu.club>
Message-ID: <80b8ae50-ca27-674f-0e7e-79b931bae199@waifu.club> (sfid-20160921_194543_088637_754CA7A6)
Date: Wed, 21 Sep 2016 19:44:34 +0200
MIME-Version: 1.0
In-Reply-To: <wrfj4m5acouw.fsf@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------099E6E528E3CF4FEEE9FCA65"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------099E6E528E3CF4FEEE9FCA65
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Oops, forgot to forward the previous reply to the mailing list.

I have attached the output of iw link

the AP is an asus dsl-n55u router in 2.4 GHz mode, using WPA2-Personal
with AES encryption. It's also running a second 5GHz wireless network
which has a different SSID.

Also, this seems to be some kind of power saving kicking in, as the dongle keeps working as long as I keep doing things over ssh.


On 09/20/2016 10:12 PM, Jes Sorensen wrote:
> "Franc[e]sco" <lolisamurai@waifu.club> writes:
>> Hi, I happen to own a RTL8192EU WiFi dongle which is marked as untested
>> by the rtl8xxxu driver.
>>
>> I'm on a linux from scratch system using kernel 4.7.3 and wpa_supplicant
>> 2.5.
>>
>> The dongle appears to connect and work fine, but after around 10 minutes
>> it deauthenticates and enters and endless loop of authentication
>> timeout. This continues even if I bring the interface down and back up
>> again. The only way to restore the connection is to physically remove
>> and re-plug the usb dongle.
>>
>> I have attached a dmesg log of connecting and entering the auth loop.
> Please provide details about the AP you are trying to connect to and iw
> link output.
>
> Jes


--------------099E6E528E3CF4FEEE9FCA65
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192eu-iw-link.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192eu-iw-link.txt"

$ ./iw enx001988001e33 link
Connected to e0:3f:49:97:0c:68 (on enx001988001e33)
	SSID: memes
	freq: 2472
	RX: 4328394 bytes (26075 packets)
	TX: 380760 bytes (2785 packets)
	signal: -60 dBm
	tx bitrate: 1.0 MBit/s

--------------099E6E528E3CF4FEEE9FCA65--
