Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout5.freenet.de ([195.4.92.95]:47065 "EHLO mout5.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab1HPS1W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 14:27:22 -0400
Received: from [195.4.92.15] (helo=5.mx.freenet.de)
	by mout5.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1QtOMB-0006kd-0x
	for linux-wireless@vger.kernel.org; Tue, 16 Aug 2011 20:27:19 +0200
Received: from p4fde0534.dip0.t-ipconnect.de ([79.222.5.52]:50633 helo=mail.maya.org)
	by 5.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #5)
	id 1QtOMA-0000Ak-Mg
	for linux-wireless@vger.kernel.org; Tue, 16 Aug 2011 20:27:18 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p7GIRWpM002353
	for <linux-wireless@vger.kernel.org>; Tue, 16 Aug 2011 20:27:32 +0200
Message-ID: <4E4AB695.5070300@01019freenet.de> (sfid-20110816_202725_942326_38F3BE31)
Date: Tue, 16 Aug 2011 20:27:33 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 7 more packets after each beacon frame
Content-Type: multipart/mixed;
 boundary="------------070603040908070304080005"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070603040908070304080005
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hello!

When examining my own AP (rt2860 based) with another STA in monitor
mode, I can see always 7 packets after each beacon frame:

- Deauthentication [Malformed Packet]
- Unrecognized
- Unrecognized
- Unrecognized
- QoS CF-Ack + CF-Poll [Malformed Packet]
- Unrecognized
- Clear-to-send [Malformed Packet]

These packets don't have any MAC address or IP address.
I attached them as text file.


I can't see these packages after beacon packets from other AP's.


What are they used for?



Thanks for your advice,
Andreas

--------------070603040908070304080005
Content-Type: text/plain;
 name="7-packets.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="7-packets.txt"

No.     Time        Source                Destination           Protocol Length Info
    154 19.455817                                               802.11   30     Deauthentication[Malformed Packet]

Frame 154: 30 bytes on wire (240 bits), 30 bytes captured (240 bits)
    Arrival Time: Aug 16, 2011 20:04:55.124169000 CEST
    Epoch Time: 1313517895.124169000 seconds
    [Time delta from previous captured frame: 0.000009000 seconds]
    [Time delta from previous displayed frame: 0.000009000 seconds]
    [Time since reference or first frame: 19.455817000 seconds]
    Frame Number: 154
    Frame Length: 30 bytes (240 bits)
    Capture Length: 30 bytes (240 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 26
    Header revision: 0
    Header pad: 0
    Header length: 26
    Present flags
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = DBM Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 33360005
    Flags: 0x50
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...1 .... = FCS at end: True
        ..0. .... = Data Pad: False
        .1.. .... = Bad FCS: True
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2442 [BG 7]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -68 dBm
    Antenna: 1
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Deauthentication
    Type/Subtype: Deauthentication (0x0c)
    Frame Control: 0xB5C3 (Normal)
        Version: 3
        Type: Management frame (0)
        Subtype: 12
        Flags: 0xB5
            .... ..01 = DS status: Frame from STA to DS via an AP (To DS: 1 From DS: 0) (0x01)
            .... .1.. = More Fragments: More fragments follow
            .... 0... = Retry: Frame is not being retransmitted
            ...1 .... = PWR MGT: STA will go to sleep
            ..1. .... = More Data: Data is buffered for STA at AP
            .0.. .... = Protected flag: Data is not protected
            1... .... = Order flag: Strictly ordered
    Duration: 58414
[Malformed Packet: IEEE 802.11]
    [Expert Info (Error/Malformed): Malformed Packet (Exception occurred)]
        [Message: Malformed Packet (Exception occurred)]
        [Severity level: Error]
        [Group: Malformed]

No.     Time        Source                Destination           Protocol Length Info
    155 19.455820                                               802.11   30     Unrecognized (Reserved frame), Flags=..mP..FTC

Frame 155: 30 bytes on wire (240 bits), 30 bytes captured (240 bits)
    Arrival Time: Aug 16, 2011 20:04:55.124172000 CEST
    Epoch Time: 1313517895.124172000 seconds
    [Time delta from previous captured frame: 0.000003000 seconds]
    [Time delta from previous displayed frame: 0.000003000 seconds]
    [Time since reference or first frame: 19.455820000 seconds]
    Frame Number: 155
    Frame Length: 30 bytes (240 bits)
    Capture Length: 30 bytes (240 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 26
    Header revision: 0
    Header pad: 0
    Header length: 26
    Present flags
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = DBM Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 33360246
    Flags: 0x50
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...1 .... = FCS at end: True
        ..0. .... = Data Pad: False
        .1.. .... = Bad FCS: True
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2442 [BG 7]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -68 dBm
    Antenna: 1
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Unrecognized (Reserved frame), Flags: ..mP..FTC
    Type/Subtype: Unknown (0x3d)
    Frame Control: 0x33DC (Normal)
        Version: 0
        Type: Unknown (3)
        Subtype: 13
        Flags: 0x33
            .... ..11 = DS status: Frame part of WDS from one AP to another AP (To DS: 1 From DS: 1) (0x03)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...1 .... = PWR MGT: STA will go to sleep
            ..1. .... = More Data: Data is buffered for STA at AP
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 22560

No.     Time        Source                Destination           Protocol Length Info
    156 19.455822                                               802.11   30     Unrecognized (Reserved frame), Flags=opm.RM.TC

Frame 156: 30 bytes on wire (240 bits), 30 bytes captured (240 bits)
    Arrival Time: Aug 16, 2011 20:04:55.124174000 CEST
    Epoch Time: 1313517895.124174000 seconds
    [Time delta from previous captured frame: 0.000002000 seconds]
    [Time delta from previous displayed frame: 0.000002000 seconds]
    [Time since reference or first frame: 19.455822000 seconds]
    Frame Number: 156
    Frame Length: 30 bytes (240 bits)
    Capture Length: 30 bytes (240 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 26
    Header revision: 0
    Header pad: 0
    Header length: 26
    Present flags
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = DBM Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 33360486
    Flags: 0x50
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...1 .... = FCS at end: True
        ..0. .... = Data Pad: False
        .1.. .... = Bad FCS: True
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2442 [BG 7]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -62 dBm
    Antenna: 1
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Unrecognized (Reserved frame), Flags: opm.RM.TC
    Type/Subtype: Unknown (0x39)
    Frame Control: 0xED9D (Normal)
        Version: 1
        Type: Unknown (3)
        Subtype: 9
        Flags: 0xED
            .... ..01 = DS status: Frame from STA to DS via an AP (To DS: 1 From DS: 0) (0x01)
            .... .1.. = More Fragments: More fragments follow
            .... 1... = Retry: Frame is being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..1. .... = More Data: Data is buffered for STA at AP
            .1.. .... = Protected flag: Data is protected
            1... .... = Order flag: Strictly ordered
    Duration: 56898

No.     Time        Source                Destination           Protocol Length Info
    157 19.455825                                               802.11   30     Unrecognized (Reserved frame), Flags=o....MFTC

Frame 157: 30 bytes on wire (240 bits), 30 bytes captured (240 bits)
    Arrival Time: Aug 16, 2011 20:04:55.124177000 CEST
    Epoch Time: 1313517895.124177000 seconds
    [Time delta from previous captured frame: 0.000003000 seconds]
    [Time delta from previous displayed frame: 0.000003000 seconds]
    [Time since reference or first frame: 19.455825000 seconds]
    Frame Number: 157
    Frame Length: 30 bytes (240 bits)
    Capture Length: 30 bytes (240 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 26
    Header revision: 0
    Header pad: 0
    Header length: 26
    Present flags
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = DBM Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 33360728
    Flags: 0x50
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...1 .... = FCS at end: True
        ..0. .... = Data Pad: False
        .1.. .... = Bad FCS: True
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2442 [BG 7]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -62 dBm
    Antenna: 1
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Unrecognized (Reserved frame), Flags: o....MFTC
    Type/Subtype: Unknown (0x3d)
    Frame Control: 0x87DF (Normal)
        Version: 3
        Type: Unknown (3)
        Subtype: 13
        Flags: 0x87
            .... ..11 = DS status: Frame part of WDS from one AP to another AP (To DS: 1 From DS: 1) (0x03)
            .... .1.. = More Fragments: More fragments follow
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..0. .... = More Data: No data buffered
            .0.. .... = Protected flag: Data is not protected
            1... .... = Order flag: Strictly ordered
    Duration: 56875

No.     Time        Source                Destination           Protocol Length Info
    158 19.455827                                               802.11   30     QoS CF-Ack + CF-Poll (No data)[Malformed Packet]

Frame 158: 30 bytes on wire (240 bits), 30 bytes captured (240 bits)
    Arrival Time: Aug 16, 2011 20:04:55.124179000 CEST
    Epoch Time: 1313517895.124179000 seconds
    [Time delta from previous captured frame: 0.000002000 seconds]
    [Time delta from previous displayed frame: 0.000002000 seconds]
    [Time since reference or first frame: 19.455827000 seconds]
    Frame Number: 158
    Frame Length: 30 bytes (240 bits)
    Capture Length: 30 bytes (240 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 26
    Header revision: 0
    Header pad: 0
    Header length: 26
    Present flags
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = DBM Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 33360969
    Flags: 0x50
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...1 .... = FCS at end: True
        ..0. .... = Data Pad: False
        .1.. .... = Bad FCS: True
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2442 [BG 7]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -67 dBm
    Antenna: 1
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 QoS CF-Ack + CF-Poll (No data)
    Type/Subtype: QoS CF-Ack + CF-Poll (No data) (0x2f)
    Frame Control: 0xF8F9 (Normal)
        Version: 1
        Type: Data frame (2)
        Subtype: 15
        Flags: 0xF8
            .... ..00 = DS status: Not leaving DS or network is operating in AD-HOC mode (To DS: 0 From DS: 0) (0x00)
            .... .0.. = More Fragments: This is the last fragment
            .... 1... = Retry: Frame is being retransmitted
            ...1 .... = PWR MGT: STA will go to sleep
            ..1. .... = More Data: Data is buffered for STA at AP
            .1.. .... = Protected flag: Data is protected
            1... .... = Order flag: Strictly ordered
    Duration: 52455
[Malformed Packet: IEEE 802.11]
    [Expert Info (Error/Malformed): Malformed Packet (Exception occurred)]
        [Message: Malformed Packet (Exception occurred)]
        [Severity level: Error]
        [Group: Malformed]

No.     Time        Source                Destination           Protocol Length Info
    159 19.455831                                               802.11   30     Unrecognized (Reserved frame), Flags=opm...FTC

Frame 159: 30 bytes on wire (240 bits), 30 bytes captured (240 bits)
    Arrival Time: Aug 16, 2011 20:04:55.124183000 CEST
    Epoch Time: 1313517895.124183000 seconds
    [Time delta from previous captured frame: 0.000004000 seconds]
    [Time delta from previous displayed frame: 0.000004000 seconds]
    [Time since reference or first frame: 19.455831000 seconds]
    Frame Number: 159
    Frame Length: 30 bytes (240 bits)
    Capture Length: 30 bytes (240 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 26
    Header revision: 0
    Header pad: 0
    Header length: 26
    Present flags
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = DBM Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 33361210
    Flags: 0x50
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...1 .... = FCS at end: True
        ..0. .... = Data Pad: False
        .1.. .... = Bad FCS: True
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2442 [BG 7]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -68 dBm
    Antenna: 1
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Unrecognized (Reserved frame), Flags: opm...FTC
    Type/Subtype: Unknown (0x38)
    Frame Control: 0xE38E (Normal)
        Version: 2
        Type: Unknown (3)
        Subtype: 8
        Flags: 0xE3
            .... ..11 = DS status: Frame part of WDS from one AP to another AP (To DS: 1 From DS: 1) (0x03)
            .... .0.. = More Fragments: This is the last fragment
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..1. .... = More Data: Data is buffered for STA at AP
            .1.. .... = Protected flag: Data is protected
            1... .... = Order flag: Strictly ordered
    Duration: 51353

No.     Time        Source                Destination           Protocol Length Info
    160 19.455833                                               802.11   30     Clear-to-send[Malformed Packet]

Frame 160: 30 bytes on wire (240 bits), 30 bytes captured (240 bits)
    Arrival Time: Aug 16, 2011 20:04:55.124185000 CEST
    Epoch Time: 1313517895.124185000 seconds
    [Time delta from previous captured frame: 0.000002000 seconds]
    [Time delta from previous displayed frame: 0.000002000 seconds]
    [Time since reference or first frame: 19.455833000 seconds]
    Frame Number: 160
    Frame Length: 30 bytes (240 bits)
    Capture Length: 30 bytes (240 bits)
    [Frame is marked: False]
    [Frame is ignored: False]
    [Protocols in frame: radiotap:wlan]
Radiotap Header v0, Length 26
    Header revision: 0
    Header pad: 0
    Header length: 26
    Present flags
        .... .... .... .... .... .... .... ...1 = TSFT: True
        .... .... .... .... .... .... .... ..1. = Flags: True
        .... .... .... .... .... .... .... .1.. = Rate: True
        .... .... .... .... .... .... .... 1... = Channel: True
        .... .... .... .... .... .... ...0 .... = FHSS: False
        .... .... .... .... .... .... ..1. .... = DBM Antenna Signal: True
        .... .... .... .... .... .... .0.. .... = DBM Antenna Noise: False
        .... .... .... .... .... .... 0... .... = Lock Quality: False
        .... .... .... .... .... ...0 .... .... = TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DB TX Attenuation: False
        .... .... .... .... .... ..0. .... .... = DBM TX Attenuation: False
        .... .... .... .... .... 1... .... .... = Antenna: True
        .... .... .... .... ...0 .... .... .... = DB Antenna Signal: False
        .... .... .... .... ..0. .... .... .... = DB Antenna Noise: False
        .... .... .... .... .1.. .... .... .... = RX flags: True
        .... .... .... .0.. .... .... .... .... = Channel+: False
        .... .... .... 0... .... .... .... .... = HT information: False
        ..0. .... .... .... .... .... .... .... = Radiotap NS next: False
        .0.. .... .... .... .... .... .... .... = Vendor NS next: False
        0... .... .... .... .... .... .... .... = Ext: False
    MAC timestamp: 33361451
    Flags: 0x50
        .... ...0 = CFP: False
        .... ..0. = Preamble: Long
        .... .0.. = WEP: False
        .... 0... = Fragmentation: False
        ...1 .... = FCS at end: True
        ..0. .... = Data Pad: False
        .1.. .... = Bad FCS: True
        0... .... = Short GI: False
    Data Rate: 1.0 Mb/s
    Channel frequency: 2442 [BG 7]
    Channel type: 802.11b (0x00a0)
        .... .... ...0 .... = Turbo: False
        .... .... ..1. .... = Complementary Code Keying (CCK): True
        .... .... .0.. .... = Orthogonal Frequency-Division Multiplexing (OFDM): False
        .... .... 1... .... = 2 GHz spectrum: True
        .... ...0 .... .... = 5 GHz spectrum: False
        .... ..0. .... .... = Passive: False
        .... .0.. .... .... = Dynamic CCK-OFDM: False
        .... 0... .... .... = Gaussian Frequency Shift Keying (GFSK): False
        ...0 .... .... .... = GSM (900MHz): False
        ..0. .... .... .... = Static Turbo: False
        .0.. .... .... .... = Half Rate Channel (10MHz Channel Width): False
        0... .... .... .... = Quarter Rate Channel (5MHz Channel Width): False
    SSI Signal: -62 dBm
    Antenna: 1
    RX flags: 0x0000
        .... .... .... .... .... ..0. = Bad PLCP: False
IEEE 802.11 Clear-to-send
    Type/Subtype: Clear-to-send (0x1c)
    Frame Control: 0x27C4 (Normal)
        Version: 0
        Type: Control frame (1)
        Subtype: 12
        Flags: 0x27
            .... ..11 = DS status: Frame part of WDS from one AP to another AP (To DS: 1 From DS: 1) (0x03)
            .... .1.. = More Fragments: More fragments follow
            .... 0... = Retry: Frame is not being retransmitted
            ...0 .... = PWR MGT: STA will stay up
            ..1. .... = More Data: Data is buffered for STA at AP
            .0.. .... = Protected flag: Data is not protected
            0... .... = Order flag: Not strictly ordered
    Duration: 64053
[Malformed Packet: IEEE 802.11]
    [Expert Info (Error/Malformed): Malformed Packet (Exception occurred)]
        [Message: Malformed Packet (Exception occurred)]
        [Severity level: Error]
        [Group: Malformed]

--------------070603040908070304080005--
